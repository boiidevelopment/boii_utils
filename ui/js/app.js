let NOTIFY = null;
let PROGRESS_CIRCLE = null;
let PROGRESS_BAR = null;
let DRAWTEXT = null;
let DIALOGUE = null;
let ACTION_MENU = null;
let CONTEXT_MENU = null;

const handlers = {
    notify: (data) => {
        if (!NOTIFY) {
            NOTIFY = new Notify();
        }
        NOTIFY.create_notification(data);
    },

    show_circle: (data) => {
        PROGRESS_CIRCLE = new ProgressCircle(data);
    },

    show_progressbar: (data) => {
        PROGRESS_BAR = new ProgressBar();
        PROGRESS_BAR.create(data.header, data.icon, data.duration);
    },

    hide_progressbar: () => {
        PROGRESS_BAR.hide_progress();
    },

    show_drawtext: (data) => {
        DRAWTEXT = new DrawText(data);
    },

    hide_drawtext: () => {
        if (DRAWTEXT) {
            DRAWTEXT.hide_text();
        }
    },

    create_action_menu: (data) => {
        ACTION_MENU = new ActionMenu();
        ACTION_MENU.create_menu(data.menu);
    },

    close_action_menu: () => {
        if (ACTION_MENU) {
            ACTION_MENU.close();
        }
    },

    create_dialogue: (data) => {
        DIALOGUE = new Dialogue(data);
    },

    create_context_menu: (data) => {
        if (!data.menu || !data.menu.header || !data.menu.content) {
            console.warn('[ContextMenu] Invalid menu data:', data);
            return;
        }
        CONTEXT_MENU = new ContextMenu(data.menu);
    },

    close_context_menu: () => {
        if (CONTEXT_MENU) {
            CONTEXT_MENU.close();
        }
    },

    copy_to_clipboard: (data) => {
        const el = document.createElement('textarea');
        el.value = data.content;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    }
};

window.addEventListener('message', function (event) {
    const data = event.data;
    const handler = handlers[data.action];
    if (handler) {
        handler(data);
    }
});