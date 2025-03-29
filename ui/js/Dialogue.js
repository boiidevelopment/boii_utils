class Dialogue {
    constructor(data) {
        this.data = data;
        this.default_settings = {
            background: 'var(--background)',
            border_radius: 'var(--border_radius)',
            text_colour: 'var(--text_colour)',
            animation: '1s',
            vignette_colour: '#000000',
            box_shadow: 'var(--box_shadow)',
        };
        this.create_container();
        this.build(data);
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
     * Closes the dialogue and cleans up the container.
     */
    close() {
        $('#main_container').empty();
        $('.dialogue_wrapper').empty();
        $.post(`https://${GetParentResourceName()}/close_dialogue`, JSON.stringify({}));
        DIALOGUE = null;
    }

    /**
     * Creates the main container for the dialogue.
     */
    create_container() {
        $('.dialogue_wrapper').remove();
        const wrapper = $('<div>').addClass('dialogue_wrapper');
        const container = $('<div>').addClass('dialogue_container');
        wrapper.append(container);
        $('#ui_layer').append(wrapper);
    }

    /**
     * Builds the dialogue UI with the provided data.
     * @param {Object} data - Dialogue data.
     */
    build(data) {
        if (data) {
            const container = $('.dialogue_container').empty();
            container.css({
                'background-color': this.default_settings.background,
                'border-radius': this.default_settings.border_radius,
                'color': this.default_settings.text_colour,
                'box-shadow': this.default_settings.box_shadow,
            });
            this.build_header(container, data.dialogue.header);
            this.build_response(container, data.dialogue.conversation[0].response);
            this.build_options(container, data.dialogue.conversation[0].options);
            $('#ui_layer').css({ position: 'relative' }).append(
                $('<div>').addClass('dialogue_vignette').css({
                    position: 'absolute',
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    'pointer-events': 'none',
                    background: `radial-gradient(circle, transparent, ${this.default_settings.vignette_colour})`,
                })
            );
        }
    }

    /**
     * Builds the dialogue header.
     * @param {Object} container - The container to append the header to.
     * @param {Object} header_data - Header data.
     */
    build_header(container, header_data) {
        const header = $('<div>').addClass('dialogue_header');
        const header_content = $('<div>').addClass('dialogue_header_content');
        if (header_data.image) {
            const header_image = $('<img>').attr('src', header_data.image).addClass('dialogue_header_image');
            header_content.append(header_image);
        }
        if (header_data.icon) {
            const header_icon = $('<i>').addClass(header_data.icon + ' dialogue_header_icon');
            header_content.append(header_icon);
        }
        if (header_data.message) {
            const messages = Array.isArray(header_data.message) ? header_data.message : [header_data.message];
            messages.forEach((message) => {
                const header_text = $('<span>').text(message).addClass('dialogue_header_text');
                header_content.append(header_text);
            });
        }
        header.append(header_content);
        container.append(header);
    }

    /**
     * Builds the response section of the dialogue.
     * @param {Object} container - The container to append the response to.
     * @param {Array|string} response_data - Response text or array of responses.
     */
    build_response(container, response_data) {
        container.find('.dialogue_response').remove();
        const response_container = $('<div>').addClass('dialogue_response');
        const responses = Array.isArray(response_data) ? response_data : [response_data];
        responses.forEach((response) => {
            const response_div = $('<div>').addClass('response').html(response);
            response_container.append(response_div);
        });
        container.append(response_container);
    }

    /**
     * Builds the options for the dialogue.
     * @param {Object} container - The container to append the options to.
     * @param {Array} options - Options array.
     */
    build_options(container, options) {
        container.find('.dialogue_options').remove();
        const option_grid = $('<div>').addClass('dialogue_options');
        options.forEach((option) => {
            const option_div = $('<div>').addClass('dialogue_option').text(option.message);
            if (option.icon) {
                const icon = $('<i>').addClass(option.icon);
                option_div.prepend(icon);
            }
            option_div.on('click', () => {
                this.handle_option_select(option);
            });
            option_grid.append(option_div);
        });
        container.append(option_grid);
    }

    /**
     * Handles option selection and updates the dialogue accordingly.
     * @param {Object} option - Selected option.
     */
    handle_option_select(option) {
        if (this.data?.dialogue?.conversation && Array.isArray(this.data.dialogue.conversation)) {
            const next_conv = this.data.dialogue.conversation.find((conv) => conv.id === option.next_id);
            if (next_conv) {
                this.build_response($('.dialogue_container'), next_conv.response);
                this.build_options($('.dialogue_container'), next_conv.options);
            } else if (option.should_end) {
                this.close();
            } else {
                console.error(`Conversation with id ${option.next_id} not found.`);
            }
        } else {
            console.error('Invalid conversation structure or missing conversation array:', JSON.stringify(this.data));
        }
        if (option.action_type && option.action) {
            $.post(`https://${GetParentResourceName()}/trigger_event`, JSON.stringify({ action_type: option.action_type, action: option.action, params: option.params || {} }));
        }
    }

}

const test_dialogue = {
    dialogue: {
        header: {
            message: 'Quarry Employee',
            icon: 'fa-solid fa-hard-hat'
        },
        conversation: [
            {
                id: 1,
                response: [
                    'Hello, welcome to the quarry.',
                    'How can I assist you today?'
                ],
                options: [
                    {
                        icon: 'fa-solid fa-question-circle',
                        message: 'Can you tell me more about what you do here?',
                        next_id: 2,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-briefcase',
                        message: 'What kind of jobs are available at the quarry?',
                        next_id: 3,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-shield-alt',
                        message: 'Are there any safety protocols I should be aware of?',
                        next_id: 4,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-door-open',
                        message: 'Goodbye!',
                        next_id: null,
                        should_end: true,
                        action_type: 'client',
                        action: 'test_event',
                        params: {}
                    }
                ]
            },
            {
                id: 2,
                response: 'We primarily focus on extracting minerals and processing them for various uses. It\'s challenging but fulfilling work.',
                options: [
                    {
                        icon: 'fa-solid fa-arrow-left',
                        message: 'Back to previous options',
                        next_id: 1,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-door-open',
                        message: 'Thank you, that\'s all for now.',
                        next_id: null,
                        should_end: true,
                        action_type: 'client',
                        action: 'test_event',
                        params: {}
                    }
                ]
            },
            {
                id: 3,
                response: 'There are several roles here, from equipment operators to safety inspectors. We\'re always looking for dedicated workers.',
                options: [
                    {
                        icon: 'fa-solid fa-arrow-left',
                        message: 'Back to previous options',
                        next_id: 1,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-door-open',
                        message: 'Thanks, I\'ll consider applying.',
                        next_id: null,
                        should_end: true,
                        action_type: 'client',
                        action: 'test_event',
                        params: {}
                    }
                ]
            },
            {
                id: 4,
                response: 'Safety is our top priority. Everyone is required to wear protective gear, and we have regular training sessions.',
                options: [
                    {
                        icon: 'fa-solid fa-arrow-left',
                        message: 'Back to previous options',
                        next_id: 1,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-door-open',
                        message: 'Good to know. Thanks for the information.',
                        next_id: null,
                        should_end: true,
                        action_type: 'client',
                        action: 'test_event',
                        params: {}
                    }
                ]
            },
            {
                id: 5,
                response: 'Please report it to our maintenance team immediately. We need to ensure a safe working environment.',
                options: [
                    {
                        icon: 'fa-solid fa-arrow-left',
                        message: 'Back to previous options',
                        next_id: 1,
                        should_end: false
                    },
                    {
                        icon: 'fa-solid fa-door-open',
                        message: 'I will let them know. Thanks!',
                        next_id: null,
                        should_end: true,
                        action_type: 'client',
                        action: 'test_event',
                        params: {}
                    }
                ]
            }
        ]
    }
};

//const dialogue_manager = new Dialogue(test_dialogue);