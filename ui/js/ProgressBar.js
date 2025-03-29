class ProgressBar {
    constructor() {
        this.default_styles = {
            background: 'var(--background)',
            bar_background: 'var(--secondary_background)',
            bar_fill: '#4dcbc2',
            border_radius: 'var(--border_radius)',
            text_colour: 'var(--text_colour)',
            animation: '1s',
            box_shadow: 'var(--box_shadow)',
        };
        this.default_position = { top: '85vh', left: '65vh' };
        this.create_progress_container();
        this.bind_key();
    }

    /**
     * Creates the progress bar container.
     */
    create_progress_container() {
        if ($('.progress_container').length === 0) {
            $('<div>').addClass('progress_container').appendTo('#ui_layer');
        }
    }

    /**
     * Binds a key event to end the progress bar on certain keys.
     */
    bind_key() {
        $(document).on('keyup', (event) => {
            if (event.key === "Escape" || event.key === "Backspace") {
                this.progress_end(false);
            }
        });
    }

    /**
     * Creates and displays a progress bar.
     * @param {string} header - The header text for the progress bar.
     * @param {string} icon - The icon class for the progress bar header.
     * @param {number} duration - The duration of the progress bar in milliseconds.
     */
    create(header, icon, duration) {
        const style = this.default_styles;
        const content = `
            <div class="progress_bar" style="color: ${style.text_colour}; background-color: ${style.background}; border-radius: ${style.border_radius}; animation: fade ${style.animation}; box-shadow: ${style.box_shadow};">
                <div class="progress_bar_header"><i class="${icon}" style="color: ${style.bar_fill}"></i> ${header}</div>
                <div class="progress_bar_body" style="background-color: ${style.bar_background}; border-radius: ${style.border_radius}; overflow: hidden;">
                    <div class="progress_fill" style="background-color: ${style.bar_fill}; width: 100%; height: 100%;"></div>
                </div>
            </div>
        `;
        $('.progress_container').html(content).fadeIn(500);
        this.animate_progress_bar(duration);
    }

    /**
     * Animates the progress bar fill and ends it when complete.
     * @param {number} duration - The duration of the progress bar animation in milliseconds.
     */
    animate_progress_bar(duration) {
        $('.progress_fill').animate({ width: '0%' }, duration, 'linear', () => {
            this.progress_end(true);
        });
    }

    /**
     * Ends the progress bar and sends the result to the server.
     * @param {boolean} success - Whether the progress completed successfully.
     */
    progress_end(success) {
        this.hide_progress();
        $(document).off('keyup');
        $.post(`https://${GetParentResourceName()}/progressbar_end`, JSON.stringify({ success: success }));
    }

    /**
     * Hides and removes the progress bar from the container.
     */
    hide_progress() {
        $('.progress_container').fadeOut(500, function () {
            $(this).empty();
        });
    }
}


//const test_progress_bar = new ProgressBar();
//test_progress_bar.create('Connecting...', 'fa-solid fa-computer', 50000);
