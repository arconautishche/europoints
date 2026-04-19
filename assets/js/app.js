// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import InitDragAndDrop from "./hooks/init_drag_and_drop"
import autoAnimate from "@formkit/auto-animate"

let Hooks = {}
Hooks.InitDragAndDrop = InitDragAndDrop
Hooks.AutoAnimate = {
  mounted() {
    autoAnimate(this.el)
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
  reconnectAfterMs: (tries) => [200, 500, 1000, 2000, 5000][tries - 1] || 5000
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

const showDisconnected = () => {
  document.getElementById("disconnected")?.classList.remove("hidden")
}
const hideDisconnected = () => {
  document.getElementById("disconnected")?.classList.add("hidden")
}
const scheduleDisconnected = (delay = DISCONNECT_GRACE_MS) => {
  if (disconnectedTimer != null) return
  disconnectedTimer = setTimeout(() => {
    disconnectedTimer = null
    if (!liveSocket.isConnected()) showDisconnected()
  }, delay)
}
const clearDisconnected = () => {
  if (disconnectedTimer != null) {
    clearTimeout(disconnectedTimer)
    disconnectedTimer = null
  }
  hideDisconnected()
}
liveSocket.socket.onOpen(clearDisconnected)
liveSocket.socket.onClose(() => scheduleDisconnected())
liveSocket.socket.onError(() => scheduleDisconnected())
document.addEventListener("visibilitychange", () => {
  if (document.visibilityState !== "visible") return
  if (liveSocket.isConnected()) return
  // Tab just woke up and the socket is down. Don't trust the in-flight
  // reconnect timer — drop it and start a fresh, fast reconnect cycle.
  clearDisconnected()
  liveSocket.disconnect()
  liveSocket.connect()
  scheduleDisconnected()
})

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

