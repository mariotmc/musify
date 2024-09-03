// app/javascript/controllers/floating_avatars_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["avatar"];

  connect() {
    this.containerRect = this.element.getBoundingClientRect();

    const rect = this.avatarTargets[0].getBoundingClientRect();
    this.speed = 1; // Constant speed for all avatars
    this.avatars = this.avatarTargets.map((avatar) => {
      return {
        element: avatar,
        width: rect.width,
        height: rect.height,
        position: {
          x: Math.random() * (this.containerRect.width - rect.width),
          y: Math.random() * (this.containerRect.height - rect.height),
        },
        velocity: this.getRandomVelocity(),
      };
    });

    console.log(this.avatars);

    this.animationId = requestAnimationFrame(this.updatePositions.bind(this));
  }

  disconnect() {
    cancelAnimationFrame(this.animationId);
  }

  getRandomVelocity() {
    const angle = Math.random() * 2 * Math.PI;
    return {
      x: Math.cos(angle) * this.speed,
      y: Math.sin(angle) * this.speed,
    };
  }

  normalizeVelocity(velocity) {
    const speed = Math.sqrt(velocity.x ** 2 + velocity.y ** 2);
    return {
      x: (velocity.x / speed) * this.speed,
      y: (velocity.y / speed) * this.speed,
    };
  }

  updatePositions() {
    this.avatars.forEach((avatar) => {
      // Update position
      avatar.position.x += avatar.velocity.x;
      avatar.position.y += avatar.velocity.y;

      // Check for collisions with container edges
      if (avatar.position.x <= 0) {
        avatar.position.x = 0;
        avatar.velocity.x = -avatar.velocity.x;
      } else if (avatar.position.x + avatar.width >= this.containerRect.width) {
        avatar.position.x = this.containerRect.width - avatar.width;
        avatar.velocity.x = -avatar.velocity.x;
      }

      if (avatar.position.y <= 0) {
        avatar.position.y = 0;
        avatar.velocity.y = -avatar.velocity.y;
      } else if (avatar.position.y + avatar.height >= this.containerRect.height) {
        avatar.position.y = this.containerRect.height - avatar.height;
        avatar.velocity.y = -avatar.velocity.y;
      }

      // Check for collisions with other avatars
      this.avatars.forEach((otherAvatar) => {
        if (avatar !== otherAvatar) {
          const dx = otherAvatar.position.x - avatar.position.x;
          const dy = otherAvatar.position.y - avatar.position.y;
          const distance = Math.sqrt(dx * dx + dy * dy);
          const minDistance = (avatar.width + otherAvatar.width) / 2;

          if (distance < minDistance) {
            // Collision detected, calculate new velocities
            const angle = Math.atan2(dy, dx);
            const sine = Math.sin(angle);
            const cosine = Math.cos(angle);

            // Rotate velocities
            const vx1 = avatar.velocity.x * cosine + avatar.velocity.y * sine;
            const vy1 = avatar.velocity.y * cosine - avatar.velocity.x * sine;
            const vx2 = otherAvatar.velocity.x * cosine + otherAvatar.velocity.y * sine;
            const vy2 = otherAvatar.velocity.y * cosine - otherAvatar.velocity.x * sine;

            // Swap velocities
            const [newVx1, newVx2] = [vx2, vx1];

            // Rotate velocities back
            avatar.velocity = this.normalizeVelocity({
              x: newVx1 * cosine - vy1 * sine,
              y: vy1 * cosine + newVx1 * sine,
            });
            otherAvatar.velocity = this.normalizeVelocity({
              x: newVx2 * cosine - vy2 * sine,
              y: vy2 * cosine + newVx2 * sine,
            });

            // Move avatars apart to prevent sticking
            const overlap = minDistance - distance;
            const moveX = (overlap * dx) / distance / 2;
            const moveY = (overlap * dy) / distance / 2;

            avatar.position.x -= moveX;
            avatar.position.y -= moveY;
            otherAvatar.position.x += moveX;
            otherAvatar.position.y += moveY;
          }
        }
      });

      // Apply the new position
      avatar.element.style.transform = `translate(${avatar.position.x}px, ${avatar.position.y}px)`;
    });

    this.animationId = requestAnimationFrame(this.updatePositions.bind(this));
  }
}
