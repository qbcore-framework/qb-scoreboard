window.addEventListener("message", (event) => {
    switch (event.data.action) {
        case "open":
            open(event.data);
            break;
        case "close":
            close();
            break;
        case "setup":
            setup(event.data);
            break;
    }
});

const open = (data) => {
    const scoreboard = document.querySelector(".scoreboard-block");
    scoreboard.style.display = "block";
    const totalPlayers = document.getElementById("total-players");
    if (totalPlayers) {
        totalPlayers.innerHTML = `<p>${data.players} of ${data.maxPlayers}</p>`;
    }
    Object.entries(data.requiredCops).forEach(([category, info]) => {
        const beam = document.querySelector(`.scoreboard-info [data-type="${category}"]`);
        if (!beam) return;
        const status = beam.querySelector(".info-beam-status");
        if (!status) return;
        if (info.busy) {
            status.innerHTML = "⏳";
        } else if (data.currentCops >= info.minimumPolice) {
            status.innerHTML = "✅";
        } else {
            status.innerHTML = "❌";
        }
    });
};

const close = () => {
    const scoreboard = document.querySelector(".scoreboard-block");
    scoreboard.style.display = "none";
};

const setup = (data) => {
    const scoreboardInfo = document.querySelector(".scoreboard-info");
    if (!scoreboardInfo) return;
    scoreboardInfo.innerHTML = "";
    Object.entries(data.items).forEach(([index, value]) => {
        const beamElement = document.createElement("div");
        beamElement.className = "scoreboard-info-beam";
        beamElement.setAttribute("data-type", index);
        const titleElement = document.createElement("div");
        titleElement.className = "info-beam-title";
        titleElement.innerHTML = `<p>${value}</p>`;
        const statusElement = document.createElement("div");
        statusElement.className = "info-beam-status";
        beamElement.appendChild(titleElement);
        beamElement.appendChild(statusElement);
        scoreboardInfo.appendChild(beamElement);
    });
    const playersBeam = document.createElement("div");
    playersBeam.className = "scoreboard-info-beam";
    const playersTitle = document.createElement("div");
    playersTitle.className = "info-beam-title";
    playersTitle.innerHTML = "<p>Total Players</p>";
    const playersStatus = document.createElement("div");
    playersStatus.className = "info-beam-status";
    playersStatus.id = "total-players";
    playersBeam.appendChild(playersTitle);
    playersBeam.appendChild(playersStatus);
    scoreboardInfo.appendChild(playersBeam);
};
