import {
  createApp,
  ref,
  onMounted,
  onUnmounted,
} from "https://unpkg.com/vue@3/dist/vue.esm-browser.prod.js";

createApp({
  setup() {
    const currentCops = ref(0);
    const maxPlayers = ref(48);
    const players = ref(1);
    const requiredCops = ref(null);
    const show = ref(false);

    const getClassStatus = (item) => {
      if (item.busy) return "fa-clock";
      if (currentCops.value >= item.minimumPolice) return "fa-check";
      return "fa-times";
    };

    const onMessage = ({ data }) => {
      switch (data.action) {
        case "open":
          currentCops.value = data.currentCops || 0;
          maxPlayers.value = data.maxPlayers || 48;
          players.value = data.players || 1;
          requiredCops.value = data.requiredCops;
          show.value = true;
          break;
        case "update_busy_state":
          requiredCops.value = data.requiredCops;
          break
        case "close":
          show.value = false;
          break;
      }
    };

    onMounted(() => {
      window.addEventListener("message", onMessage);
    });

    onUnmounted(() => {
      window.removeEventListener("message", onMessage);
    });

    return {
      currentCops,
      maxPlayers,
      players,
      requiredCops,
      show,
      getClassStatus,
    };
  },
}).mount("#app");
