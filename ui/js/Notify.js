const notify_templates = {
    success: { icon: 'fa-solid fa-check-circle', color: '#28a745' }, // Green
    error: { icon: 'fa-solid fa-times-circle', color: '#dc3545' }, // Red
    info: { icon: 'fa-solid fa-info-circle', color: '#17a2b8' }, // Blue
    warning: { icon: 'fa-solid fa-exclamation-circle', color: '#ffc107' }, // Yellow
    primary: { icon: 'fa-solid fa-star', color: '#007bff' }, // Bright Blue
    secondary: { icon: 'fa-solid fa-layer-group', color: '#6c757d' }, // Gray
    light: { icon: 'fa-solid fa-sun', color: '#f8f9fa' }, // Light Gray
    dark: { icon: 'fa-solid fa-moon', color: '#343a40' }, // Dark Gray
    critical: { icon: 'fa-solid fa-skull-crossbones', color: '#d9534f' }, // Dark Red
    neutral: { icon: 'fa-solid fa-minus-circle', color: '#bdc3c7' }, // Light Gray
};

class Notify {
    constructor() {
        this.default_position = { top: '40vh', right: '1vw', alignment: 'flex-end' };
        this.default_styles = {
            background: 'var(--background)',
            border_radius: '3px',
            text_colour: 'var(--text_colour)',
            box_shadow: 'var(--box_shadow)',
            header_font: 'Kanit',
            message_font: 'Roboto'
        };
        this.create_container();
    }

    /**
     * Creates the notification container on the page.
     */
    create_container() {
        if ($('#notify_container').length === 0) {
            $('#ui_layer').append(`
                <div id="notify_container" class="notification_container" style="
                    position: absolute;
                    top: ${this.default_position.top};
                    right: ${this.default_position.right};
                    display: flex;
                    flex-direction: column;
                    align-items: ${this.default_position.alignment};
                "></div>
            `);
        }
    }

    /**
     * Creates and displays a notification.
     * @param {Object} options - Options for customizing the notification.
     */
    create_notification({ type = 'info', header = '', message = 'No message provided', duration = 5000, style = {} }) {
        const { icon, color } = notify_templates[type] || notify_templates.info;
        const applied_style = { ...this.default_styles, ...style };

        const custom_style = `
            background: ${applied_style.background};
            border: 2px solid rgba(0, 0, 0, 0.5);
            border-radius: ${applied_style.border_radius};
            color: ${applied_style.text_colour};
            box-shadow: ${applied_style.box_shadow};
        `;

        const notification = `
            <div class="notification" style="${custom_style} ${!header ? 'min-height: 2.2vh' : ''}">
                <div class="notification_content">
                    <i class="${style.custom_icon || icon} notification_icon" style="color: ${color};"></i>
                    ${header ? `<span class="notification_header_text" style="font-family: ${applied_style.header_font}; margin-bottom: 0.5vh;">${header}</span>` : ''}
                    ${!header ? `<p class="notification_message" style="font-family: ${applied_style.message_font};">${message}</p>` : ''}
                </div>
                ${header ? `<p class="notification_message" style="font-family: ${applied_style.message_font};">${message}</p>` : ''}
                ${duration > 0 ? `
                <div class="notification_progress_bar" style="background-color: ${applied_style.box_shadow}; border-radius: ${applied_style.border_radius}; position: relative; overflow: hidden;">
                    <div class="progress_fill" style="background-color: ${color}; width: 100%; height: 100%;"></div>
                </div>` : ''}
            </div>
        `;

        const $notification = $(notification);
        $('#notify_container').append($notification);

        // Animate progress bar
        if (duration > 0) {
            $notification.find('.progress_fill').animate({ width: '0%' }, duration, 'linear');
            setTimeout(() => $notification.fadeOut(400, () => $notification.remove()), duration);
        }
    }
}

/*
const notify = new Notify();

notify.create_notification({
    type: 'success',
    header: 'Success',
    message: 'This is a success notification, with a header!',
    duration: 50000
});

notify.create_notification({
    type: 'info',
    header: 'Information',
    message: 'This is an info notification, with a header!',
    duration: 20000
});

notify.create_notification({
    type: 'error',
    message: 'This is an error notification!',
    duration: 40000
});

notify.create_notification({
    type: 'info',
    message: 'This is a warning notification!',
    duration: 35000
});

notify.create_notification({
    type: 'primary',
    message: 'This is a primary notification!',
    duration: 33000
});
*/