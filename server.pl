#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::Date;
use Mango;
use Mango::BSON ':bson';

plugin 'PODRenderer';

helper mango => sub { state $mango = Mango->new($ENV{DB}) };
helper books => sub { state $book  = shift->mango->db->collection('books') };

helper dt => sub { Mojo::Date->new->epoch($_[1] / 1000)->to_datetime };

under sub {
  my $self = shift;

  # No caching, and allow CORS from anywhere
  $self->res->headers->cache_control('no-cache');
  $self->res->headers->access_control_allow_origin('*');

  return 1;
};

get '/api' => sub {
  my $self = shift;

  # ripped straight from the Mango README.md, for testing
  my $collection = $self->mango->db->collection('visitors');
  my $ip         = $self->tx->remote_address;

  $collection->insert(
    {when => bson_time, from => $ip} => sub {
      my ($collection, $err, $oid) = @_;

      return $self->reply->exception($err) if $err;

      $collection->find->sort({when => -1})->fields({_id => 0})->all(
        sub {
          my ($collection, $err, $docs) = @_;

          return $self->reply->exception($err) if $err;

          $self->render(json => $docs);
        }
      );
    }
  );
};

get '/api/books' => sub {
  my $self = shift;

  $self->books->find->all(
    sub {
      my ($collection, $err, $books) = @_;

      return $self->reply->exception($err) if $err;

      map { $_->{releaseDate} = $self->dt($_->{releaseDate}) } @$books;

      app->log->info('got list of all books');
      $self->render(json => $books);
    }
  );
};

post '/api/books' => sub {
  my $self = shift;

  my $book = $self->req->json;

  $self->books->insert(
    $book => sub {
      my ($collection, $err, $oid) = @_;

      return $self->reply->exception($err) if $err;

      $book->{_id} = $oid;
      $book->{releaseDate} = $self->dt($book->{releaseDate});

      app->log->info("created $oid");
      $self->render(json => $book);
    }
  );
};

get '/api/books/:id' => sub {
  my $self = shift;
  my $id   = $self->stash('id');

  app->log->info("getting $id");
  $self->books->find_one(
    bson_oid($id) => sub {
      my ($collection, $err, $book) = @_;

      return $self->reply->exception($err) if $err;

      $book->{releaseDate} = $self->dt($book->{releaseDate});

      api->log->info("got book $id");
      $self->render(json => $book);
    }
  );
};

put '/api/books/:id' => sub {
  my $self = shift;
  my $id   = $self->stash('id');

  my $book = $self->req->json;

  app->log->info("Updating book $id");
  $self->books->update(
    bson_oid($id),
    $book => sub {
      my ($collection, $err, $doc) = @_;

      return $self->reply->exception($err) if $err;

      $book->{releaseDate} = $self->dt($book->{releaseDate});

      app->log->info("updated $id");
      $self->render(json => $book);
    }
  );
};

del '/api/books/:id' => sub {
  my $self = shift;
  my $id   = $self->stash('id');

  app->log->info("deleting $id");
  $self->books->remove(
    bson_oid($id) => sub {
      my ($collection, $err, $doc) = @_;

      return $self->reply->exception($err) if $err;

      app->log->info("removed $id");
      $self->render(json => '');
    }
  );
};

app->start;
