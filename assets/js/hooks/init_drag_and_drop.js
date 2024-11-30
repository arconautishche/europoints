import Sortable from "../../vendor/sortable.min.js"

export default InitDragAndDrop = {
  mounted() {
    let sorter = new Sortable(this.el, {
      animation: 200,
      delay: 100,
      dragClass: "drag-item",
      ghostClass: "drag-ghost",
      forceFallback: true,
      filter: ".not-draggable",
      onEnd: e => {
        let params = { old: e.oldIndex, new: e.newIndex, ...e.item.dataset }
        this.pushEventTo(this.el, "reposition", params)
      }
    })
  }
}