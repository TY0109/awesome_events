import Turbolinks from "turbolinks"

// formによるGETリクエストをTurbolinks環境でリンクをクリックしたのと同じ挙動に変換する
document.addEventListener("turbolinks:load", function(event) {
  const forms = document.querySelectorAll("form[method=get][data-remote=true]")
  for (const form of forms) {
    form.addEventListener("ajax:beforeSend", function({ detail: [, { url }] }) {
      Turbolinks.visit(url)
      event.preventDefault()
    })
  }
})
