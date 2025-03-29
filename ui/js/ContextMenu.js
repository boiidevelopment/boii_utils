class ContextMenu {
    constructor(data) {
        this.data = data || {};
        this.init_menu();
        this.bind_exit_event();
    }

    /**
     * Binds the exit event for closing the menu.
     */
    bind_exit_event() {
        $(document).ready(() => {
            $(document).keyup((e) => this.handle_exit(e));
        });
    }

    /**
     * Handles exiting the menu via keypress.
     * @param {Event} e - The keyup event.
     */
    handle_exit(e) {
        if (e.key === 'Escape' || e.key === 'Backspace') {
            this.close();
        }
    }

    /**
     * Initializes and renders the menu.
     */
    init_menu() {
        this.menu_container = this.create_menu_container();
        if (this.data.header) {
            const header = this.create_menu_header(this.data.header);
            this.menu_container.append(header);
        }
        if (Array.isArray(this.data.content) && this.data.content.length > 0) {
            this.data.content.forEach((option) => {
                const menu_item = this.create_menu_option(option);
                this.menu_container.append(menu_item);
            });
        } else {
            console.warn('[ContextMenu] No content provided for the menu.');
        }
        $('#ui_layer').append(this.menu_container);
    }

    /**
     * Creates the main container for the context menu.
     */
    create_menu_container() {
        const container = $('<div>').addClass('context_menu_wrapper');
        container.on('click', (e) => e.stopPropagation()); 
        return container;
    }

    /**
     * Creates the menu header.
     */
    create_menu_header(header_data) {
        const header = $('<div>').addClass('context_menu_header');
        if (header_data.image) {
            const image = $('<img>').attr('src', header_data.image);
            header.append(image);
        }
        if (header_data.title) {
            const title = $('<div>').addClass('context_menu_header_title').text(header_data.title);
            header.append(title);
        }
        if (header_data.subtitle) {
            const subtitle = $('<div>').addClass('context_menu_header_subtitle').text(header_data.subtitle);
            header.append(subtitle);
        }
        return header;
    }

    /**
     * Creates an individual menu option.
     * @param {Object} option - The data for the menu option.
     * @returns {jQuery} - The menu option element.
     */
    create_menu_option(option) {
        const item = $('<div>').addClass('context_menu_option');
        if (option.icon) {
            const icon = $('<i>').addClass('context_menu_icon').addClass(option.icon);
            item.append(icon);
        }
        item.append($('<span>').text(option.label));
        if (option.disabled) {
            item.addClass('disabled');
        } else {
            item.on('click', () => this.handle_options(option));
        }
        return item;
    }

    /**
     * Handles clicks on menu options.
     * @param {Object} option - The clicked menu option.
     */
    handle_options(option) {
        if (option.action) {
            $.post(`https://${GetParentResourceName()}/context_menu_trigger_event`,JSON.stringify(option.action));
        }
        if (option.should_close) {
            this.close();
        }
    }

    /**
     * Closes the context menu.
     */
    close() {
        $(".context_menu_wrapper").fadeOut(200, function () {
            $(this).remove();
        });
        $.post(`https://${GetParentResourceName()}/close_context_menu`, {});
    }
}

const test_context_menu = {
    header: {
        title: 'New Context Menu',
        subtitle: 'Choose an option',
        image: 'https://placehold.co/286x96',
    },
    content: [
        {
            label: 'Open Profile',
            icon: 'fa-solid fa-user',
            action: { type: 'client_event', name: 'open_profile' },
            should_close: true,
            disabled: true,
        },
        {
            label: 'Enable Notifications',
            icon: 'fa-solid fa-bell',
            action: { type: 'client_event', name: 'toggle_notifications' },
        },
        {
            label: 'Disabled Option',
            icon: 'fa-solid fa-ban',
            disabled: true,
        },
    ],
};

//const test_context = new ContextMenu(test_context_menu);
