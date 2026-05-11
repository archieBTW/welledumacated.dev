export class MusicPlayer {
  constructor(containerId) {
    this.container = document.getElementById(containerId);
    this.tracks = [
      { name: "Artificial Intelligence", file: "ai.wav" },
      { name: "Cross Tops", file: "crosstops.wav" },
      { name: "Untitled", file: "cunt.wav" },
      { name: "Cups", file: "cups.wav" },
      { name: "Elixir", file: "elixir.wav" },
      { name: "Florence", file: "florence.wav" },
      { name: "Good Idea", file: "it_seemed_like_a_good_idea_at_the_time.wav" },
      { name: "Mercy", file: "mercy.wav" },
      { name: "Midnight Oil", file: "midnight_oil.wav" },
      { name: "Smart Man", file: "smart_man.wav" },
      { name: "Take It Apart", file: "take_it_apart.wav" },
      { name: "That's How", file: "thats_how.wav" },
      { name: "Third Time", file: "third_time.wav" }
    ];
    this.currentTrackIndex = 0;
    this.audio = new Audio();
    this.isPlaying = false;

    this.init();
  }

  init() {
    this.render();
    this.setupListeners();
    this.loadTrack(0);
  }

  loadTrack(index) {
    this.currentTrackIndex = index;
    const track = this.tracks[index];
    this.audio.src = `/music/${track.file}`;
    this.updateUI();
  }

  updateUI() {
    const track = this.tracks[this.currentTrackIndex];
    const display = this.container.querySelector('.now-playing-text');
    if (display) {
      display.textContent = track.name;
    }

    const items = this.container.querySelectorAll('.playlist-item');
    items.forEach((item, idx) => {
      item.classList.toggle('active', idx === this.currentTrackIndex);
    });

    const playBtn = this.container.querySelector('.play-pause-btn');
    if (playBtn) {
      playBtn.textContent = this.isPlaying ? 'PAUSE' : 'PLAY';
    }
  }

  playPause() {
    if (this.isPlaying) {
      this.audio.pause();
    } else {
      this.audio.play();
    }
    this.isPlaying = !this.isPlaying;
    this.updateUI();
  }

  stop() {
    this.audio.pause();
    this.audio.currentTime = 0;
    this.isPlaying = false;
    this.updateUI();
  }

  next() {
    this.currentTrackIndex = (this.currentTrackIndex + 1) % this.tracks.length;
    this.loadTrack(this.currentTrackIndex);
    if (this.isPlaying) this.audio.play();
  }

  prev() {
    this.currentTrackIndex = (this.currentTrackIndex - 1 + this.tracks.length) % this.tracks.length;
    this.loadTrack(this.currentTrackIndex);
    if (this.isPlaying) this.audio.play();
  }

  setupListeners() {
    this.container.addEventListener('click', (e) => {
      if (e.target.classList.contains('play-pause-btn')) this.playPause();
      if (e.target.classList.contains('stop-btn')) this.stop();
      if (e.target.classList.contains('next-btn')) this.next();
      if (e.target.classList.contains('prev-btn')) this.prev();
      if (e.target.classList.contains('playlist-item')) {
        const index = parseInt(e.target.dataset.index);
        this.loadTrack(index);
        this.isPlaying = true;
        this.audio.play();
      }
    });

    this.audio.addEventListener('ended', () => this.next());
    
    this.audio.addEventListener('timeupdate', () => {
      const progress = this.container.querySelector('.progress-bar-fill');
      if (progress) {
        const percent = (this.audio.currentTime / this.audio.duration) * 100;
        progress.style.width = `${percent}%`;
      }
    });
  }

  render() {
    this.container.innerHTML = `
      <div class="player-wrapper">
        <div class="player-header">
          <span class="player-title">MySpace Music Player</span>
          <div class="visualizer-mini">
            <div class="bar"></div>
            <div class="bar"></div>
            <div class="bar"></div>
            <div class="bar"></div>
          </div>
        </div>
        
        <div class="now-playing-box">
          <div class="marquee-mini">
            <span class="now-playing-text">Select a track...</span>
          </div>
        </div>

        <div class="progress-container">
          <div class="progress-bar-bg">
            <div class="progress-bar-fill"></div>
          </div>
        </div>

        <div class="player-controls-main">
          <button class="btn-retro prev-btn">PREV</button>
          <button class="btn-retro play-pause-btn">PLAY</button>
          <button class="btn-retro stop-btn">STOP</button>
          <button class="btn-retro next-btn">NEXT</button>
        </div>

        <div class="playlist-container">
          ${this.tracks.map((track, index) => `
            <div class="playlist-item" data-index="${index}">
              ${index + 1}. ${track.name}
            </div>
          `).join('')}
        </div>
      </div>
    `;
  }
}
