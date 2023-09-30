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
          currentCops.value = data.currentCops;
          maxPlayers.value = data.maxPlayers;
          players.value = data.players;
          requiredCops.value = data.requiredCops;
          show.value = true;
          break;
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
