const canvas = document.getElementById('flame-canvas');
const ctx = canvas.getContext('2d');

let width, height;
let particles = [];
const mouse = { x: -100, y: -100 };

function resize() {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
}

window.addEventListener('resize', resize);
resize();

window.addEventListener('mousemove', (e) => {
    mouse.x = e.clientX;
    mouse.y = e.clientY;
});

class Particle {
    constructor() {
        this.reset();
    }

    reset() {
        this.x = mouse.x + (Math.random() * 20 - 10);
        this.y = mouse.y + (Math.random() * 20 - 10);
        this.vx = (Math.random() * 2 - 1);
        this.vy = -(Math.random() * 3 + 1);
        this.life = 1;
        this.decay = 0.02 + Math.random() * 0.05;
        this.size = Math.random() * 10 + 5;
        this.color = `hsla(${Math.random() * 30 + 270}, 100%, 50%, ${this.life})`;
    }

    update() {
        this.x += this.vx;
        this.y += this.vy;
        this.life -= this.decay;
        this.size *= 0.95;

        if (this.life <= 0) {
            this.reset();
        }
    }

    draw() {
        ctx.fillStyle = `hsla(${Math.random() * 30 + 270}, 100%, 50%, ${this.life})`;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
        ctx.fill();
    }
}

for (let i = 0; i < 50; i++) {
    particles.push(new Particle());
}

function animate() {
    ctx.clearRect(0, 0, width, height);
    
    // Add glow effect
    ctx.globalCompositeOperation = 'screen';
    
    particles.forEach(p => {
        p.update();
        p.draw();
    });

    requestAnimationFrame(animate);
}

animate();
