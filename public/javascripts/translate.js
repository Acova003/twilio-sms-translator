var url = "https://translate.yandex.net/api/v1.5/tr.json/translate",

function translateText() {
  var url = "https://translate.yandex.net/api/v1.5/tr.json/translate",
  document.querySelector('#translate').addEventListener('click', function() {
    var xhr = new XMLHttpRequest(),
    textAPI = document.querySelector('#content').value,
    langAPI = document.querySelector('#language').value
    data = "key="+ENV['YANDEX_API_KEY']+"&text="+textAPI+"&lang="+langAPI;
    xhr.open("POST",url,true);
    xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xhr.send(data);
    var res = this.responseText;
    document.querySelector('#json').innerHTML = res;
    var json = JSON.parse(res);
    TRANSLATED = json.text[0];
    });
}
