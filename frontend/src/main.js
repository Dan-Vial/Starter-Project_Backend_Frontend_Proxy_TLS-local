import './style.css'
import javascriptLogo from './javascript.svg'
import viteLogo from '/vite.svg'
import { setupCounter } from './counter.js'

document.querySelector('#app').innerHTML = `
  <div>
    <a href="https://vite.dev" target="_blank">
      <img src="${viteLogo}" class="logo" alt="Vite logo" />
    </a>
    <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript" target="_blank">
      <img src="${javascriptLogo}" class="logo vanilla" alt="JavaScript logo" />
    </a>
    <h1>Hello Vite!</h1>
    <div class="card">
      <button id="counter" type="button"></button>
      <button id="api-button" type="button">API</button>
    </div>
    <p class="read-the-docs">
      Click on the Vite logo to learn more
    </p>
  </div>
`

const apiURL = "https://api.localhost:4443/"
const apiButton = document.querySelector('#api-button')

async function fetchData() {
  try {
    const res = await fetch(`${apiURL}users`)
    if (!res.ok) {
      throw new Error(`Erreur HTTP : ${res.status}`)
    }
    const json = await res.json()

    // injecter la réponse dans le DOM
    apiButton.textContent = json.msg
  } catch (err) {
    console.error("Erreur API:", err)
    apiButton.textContent =
      "Impossible de récupérer les données 😢"
  }
}

setupCounter(document.querySelector('#counter'))
apiButton.addEventListener("click", fetchData)
