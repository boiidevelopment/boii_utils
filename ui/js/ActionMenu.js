class ActionMenu {
    constructor() {
        this.menu_stack = [];
        this.is_menu_active = false;
        this.default_settings = {
            font: 'Kanit',
            icon_colour: '#4dcbc2',
        };
        this.create_menu_container();
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
     * Creates the main container for the action menu.
     */
    create_menu_container() {
        this.menu_container = $('<div>').addClass('action_menu_container');
        $('#ui_layer').append(this.menu_container);
    }

    /**
     * Creates and displays a menu with given actions.
     * @param {Array} actions - The menu actions to display.
     */
    create_menu(actions) {
        this.menu_stack.push(actions);
        this.render_menu(actions);
        this.is_menu_active = true;
    }

    /**
     * Renders the current menu based on the stack.
     * @param {Array} actions - The menu actions to render.
     */
    render_menu(actions) {
        const colour = this.default_settings.icon_colour;
        this.menu_container.empty();
        const menu_left = $('<div>').addClass('actions left');
        const menu_right = $('<div>').addClass('actions right');
        const icon = this.menu_stack.length > 1 ? 'fa fa-rotate-left' : 'fa fa-times';
        const center_button = $('<div>').addClass('center_button').html(`<i class='${icon}' style='color:${colour}'></i>`);
        center_button.on('click', () => this.handle_center_button_click());
        actions.forEach((action, index) => {
            let action_html = this.create_action_element(action, index);
            action_html.on('click', () => this.handle_action_click(action));
            if (index % 2 === 0) {
                menu_right.append(action_html);
            } else {
                menu_left.append(action_html);
            }
        });
        this.adjust_action_positions(menu_left, menu_right);
        this.menu_container.append(menu_left, center_button, menu_right);
    }

    /**
     * Creates a single action element.
     * @param {Object} action - The action details.
     * @param {number} index - The index of the action.
     * @returns {Object} jQuery object for the action element.
     */
    create_action_element(action, index) {
        const colour = action.colour || this.default_settings.icon_colour;
        const font = this.default_settings.font;
        const label_html = `<span class='label' style='font-family: ${font};'>${action.label}</span>`;
        const icon_html = `<span class='icon' style='color:${colour}'><i class='${action.icon}'></i></span>`;
        let action_html = $('<div>').addClass('action');
        if (index % 2 === 0) {
            action_html.html(`<div class='label_container'>${icon_html}${label_html}</div>`);
        } else {
            action_html.html(`<div class='label_container'>${label_html}${icon_html}</div>`);
        }
        return action_html;
    }

    /**
     * Adjusts the position of actions within the menu.
     * @param {Object} menu_left - The left menu container.
     * @param {Object} menu_right - The right menu container.
     */
    adjust_action_positions(menu_left, menu_right) {
        const count_left = menu_left.children().length;
        const count_right = menu_right.children().length;
        if (count_left > 2) {
            menu_left.children().first().css('transform', 'translateX(10%)');
            menu_left.children().last().css('transform', 'translateX(10%)');
        } else {
            menu_left.children().first().css('transform', '');
            menu_left.children().last().css('transform', '');
        }
        if (count_right > 2) {
            menu_right.children().first().css('transform', 'translateX(-10%)');
            menu_right.children().last().css('transform', 'translateX(-10%)');
        } else {
            menu_right.children().first().css('transform', '');
            menu_right.children().last().css('transform', '');
        }
    }

    /**
     * Handles the click event for an action.
     * @param {Object} action - The action details.
     */
    handle_action_click(action) {
        if (action.submenu) {
            this.create_menu(action.submenu);
        } else {
            $.post(`https://${GetParentResourceName()}/action_menu_trigger_event`, JSON.stringify({
                action_type: action.action_type,
                action: action.action,
                params: action.params
            }));
            if (this.menu_stack.length === 1) {
                this.is_menu_active = false;
                this.close();
            }
        }
    }

    /**
     * Handles the center button click to navigate back or close the menu.
     */
    handle_center_button_click() {
        if (this.menu_stack.length > 1) {
            this.menu_stack.pop();
            this.render_menu(this.menu_stack[this.menu_stack.length - 1]);
        } else {
            this.close();
        }
    }

    /**
     * Closes the menu and clears the stack.
     */
    close() {
        this.menu_container.empty();
        this.is_menu_active = false;
        $.post(`https://${GetParentResourceName()}/close_action_menu`, JSON.stringify({}));
    }
}


const test_menu = [
    {
        label: 'Main Menu',
        icon: 'fa-solid fa-bars',
        colour: '#4dcbc2',
        submenu: [
            {
                label: 'Submenu 1',
                icon: 'fa-solid fa-arrow-right',
                colour: '#4dcbc2',
                submenu: [
                    {
                        label: 'Action 1',
                        icon: 'fa-solid fa-cog',
                        colour: '#4dcbc2',
                        action_type: 'client_event',
                        action: 'some_event',
                        params: {}
                    }
                ]
            }
        ]
    },
    {
        label: 'Quick Action',
        icon: 'fa-solid fa-bolt',
        action_type: 'client_event',
        action: 'quick_event',
        params: {}
    },
];

//const action_menu = new ActionMenu();
//action_menu.create_menu(test_menu);
