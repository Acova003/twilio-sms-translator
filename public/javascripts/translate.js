
function translateText() {
  var key = ENV['YANDEX_API_KEY']
  translate = require('yandex-translate')(key);

  TRANSLATED= translate.translate('You can burn my house, steal my car, drink my liquor from an old fruitjar.', { to: 'es' }, function(err, res) {
  console.log(res.text);
});
}
