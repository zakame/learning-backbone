require('../../globals');

var AppView = require('./views/app');
var Router = require('./routers/router');

new AppView();
new Router();
Backbone.history.start();
