class ProgressCircle {
    constructor(options) {
        this.settings = {
            font: 'Kanit',
            bar_color: '#4dcbc2',
            background_color: '#1f1e1e',
        };
        this.build(options.message, options.duration);
    }

    /**
     * Builds the progress circle UI and handles animation.
     * @param {string} message - The message to display below the timer.
     * @param {number} duration - The duration of the timer in seconds.
     */
    build(message, duration) {
        const { font, bar_color, background_color } = this.settings;
        const content = `
            <div id="prog_timer" class="prog_timer">
                <div class="progress_circle">
                    <canvas id="progress_canvas" width="120" height="120"></canvas>
                    <div class="timer" id="timer" style="font-family: ${font};"></div>
                </div>
                <div class="status_message" id="status_message" style="font-family: ${font};">${message}</div>
            </div>
        `;
        $('#ui_layer').append(content);
        $('#prog_timer').fadeIn('slow');

        const canvas = document.getElementById('progress_canvas');
        const ctx = canvas.getContext('2d');
        const radius = 40;

        /**
         * Draws the background circle.
         */
        const draw_background = () => {
            ctx.beginPath();
            ctx.arc(60, 60, radius, 0, 2 * Math.PI);
            ctx.fillStyle = background_color;
            ctx.fill();
        };

        /**
         * Draws the progress arc.
         * @param {number} progress - Progress percentage (0 to 1).
         */
        const draw_progress = (progress) => {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            draw_background();
            ctx.beginPath();
            ctx.arc(60, 60, radius, -Math.PI / 2, -Math.PI / 2 + progress * 2 * Math.PI);
            ctx.strokeStyle = bar_color;
            ctx.lineWidth = 8;
            ctx.stroke();
        };

        /**
         * Animates the progress circle.
         * @param {DOMHighResTimeStamp} timestamp - The current time in milliseconds.
         */
        const animate = (timestamp) => {
            if (!this.start_time) this.start_time = timestamp;
            const elapsed = (timestamp - this.start_time) / 1000;
            const time_left = Math.max(0, duration - elapsed);
            const progress = time_left / duration;

            draw_progress(progress);
            $('#timer').text(Math.ceil(time_left));

            if (time_left > 0) {
                requestAnimationFrame(animate);
            } else {
                this.cleanup();
            }
        };

        requestAnimationFrame(animate);
    }

    /**
     * Cleans up the UI and sends a post-event when the timer ends.
     */
    cleanup() {
        $('#prog_timer').fadeOut('slow', () => {
            $('#prog_timer').remove();
            PROGRESS_CIRCLE = null;
            $.post(`https://${GetParentResourceName()}/circle_end`, JSON.stringify({}));
        });
    }
}

//const test_prog_circle = new ProgressCircle({ message: 'Repairing vehicle...', duration: 99 });