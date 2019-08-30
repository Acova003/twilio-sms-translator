
function translateText() {
  const language = document.getElementById('language').value;
  content = document.getElementById('content').value;
  key = ENV['YANDEX_API_KEY']
  translate = require('yandex-translate')(key);

  translate.translate('${content}', { to: '${language}' }, function(err, res) {
  console.log(res.text);
});
}
