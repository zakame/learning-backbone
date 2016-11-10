require('../../globals');
require('../css/app.css');

require('jquery-dateformat');
require('jquery-ui');
require('jquery-ui/ui/widgets/datepicker');

var LibraryView = require('./views/library');

$('#releaseDate').datepicker();
new LibraryView();
