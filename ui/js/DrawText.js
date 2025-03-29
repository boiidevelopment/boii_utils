class DrawText {
    constructor(options) {
        this.default_style = {
            background: 'var(--background)',
            border_radius: 'var(--border_radius)',
            text_colour: 'var(--text_colour)',
            animation: '2s',
            box_shadow: 'var(--box_shadow)',
            bar_background: 'var(--secondary_background)',
            bar_fill: '#4dcbc2'
        };
        this.default_position = { top: '40vh', left: '1vh' };
        this.default_alignment = 'flex-start';

        this.create_draw_text_container();
        this.show_text(options);
    }

    /**
     * Creates the draw text container on the page.
     */
    create_draw_text_container() {
        const container = $('<div>').addClass('draw_text_container').css({
            'position': 'fixed',
            'top': this.default_position.top,
            'left': this.default_position.left,
            'display': 'flex',
            'flex-direction': 'column',
            'align-items': this.default_alignment
        });
        $('#ui_layer').append(container);
    }

    /**
     * Displays the draw text with the specified options.
     * @param {Object} options - Options for customizing the displayed text.
     */
    show_text(options) {
        const { header, message, icon, keypress, duration, style } = options;
        const applied_style = { ...this.default_style, ...style };
        const draw_text_container = $('.draw_text_container');
        draw_text_container.empty();

        let icon_html = '';
        if (icon) {
            icon_html = `<i class="${icon}" style="color: ${applied_style.bar_fill}"></i>`;
        } else if (keypress) {
            icon_html = `<span class="key_indicator" style="color: ${applied_style.bar_fill}">${keypress.toUpperCase()}</span>`;
        }

        const border = `${applied_style.border_size || '1px solid'} ${applied_style.border_colour || 'transparent'}`;
        const draw_text_html = `
            <div class="draw_text" style="color: ${applied_style.text_colour}; background-color: ${applied_style.background}; border: ${border}; border-radius: ${applied_style.border_radius}; animation: fade ${applied_style.animation}; box-shadow: ${applied_style.box_shadow};">
                <div class="draw_text_header">${icon_html} ${header}</div>
                <div class="draw_text_message">${message}</div>
                ${duration > 0 ? `<div class="draw_text_progress_bar" style="background-color: ${applied_style.bar_background}; border-radius: ${applied_style.border_radius}; position: relative; overflow: hidden;"><div class="progress_fill" style="background-color: ${applied_style.bar_fill}; width: 100%; height: 100%;"></div></div>` : ''}
            </div>
        `;
        draw_text_container.html(draw_text_html);
        draw_text_container.fadeIn(500);

        if (duration > 0) {
            this.animate_progress_bar(duration);
            setTimeout(() => {
                this.hide_text();
                $.post(`https://${GetParentResourceName()}/hide_drawtext`, JSON.stringify({}));
            }, duration);
        }
    }

    /**
     * Animates the progress bar over the specified duration.
     * @param {number} duration - Duration in milliseconds for the progress bar animation.
     */
    animate_progress_bar(duration) {
        $('.progress_fill').animate({ width: '0%' }, duration, 'linear');
    }

    /**
     * Hides the currently displayed text.
     */
    hide_text() {
        $('.draw_text').fadeOut(500, function() {
            $(this).remove();
        });
    }
}

/*
const drawtext = new DrawText({
    header: 'Enter Building',
    message: 'Press the indicated key to enter',
    keypress: 'e',
    icon: 'fa-solid fa-gear'
});
*/