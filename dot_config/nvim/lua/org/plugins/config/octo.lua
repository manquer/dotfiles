return function()
  local ok, octo = pcall(require, "octo")
  if not ok then
    vim.schedule(function()
      vim.notify(("nvim config: octo not available\n%s"):format(octo), vim.log.levels.INFO)
    end)
    return
  end

  octo.setup({
    use_local_fs = false, -- use local files on right side of reviews
    enable_builtin = false, -- shows a list of builtin actions when no action is provided
    default_remote = { "upstream", "origin" }, -- order to try remotes
    default_merge_method = "merge", -- default merge method for `Octo pr merge`
    default_delete_branch = false, -- delete branch when merging PRs
    ssh_aliases = {}, -- ssh alias overrides
    picker = "telescope", -- picker backend
    picker_config = {
      use_emojis = false, -- only used by fzf-lua picker for now
      mappings = {
        open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
        copy_url = { lhs = "<C-y>", desc = "copy url to clipboard" },
        checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
        merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
      },
    },
    comment_icon = "▎", -- comment marker
    outdated_icon = "󰅒 ", -- outdated indicator
    resolved_icon = " ", -- resolved indicator
    reaction_viewer_hint_icon = " ", -- marker for user reactions
    commands = {}, -- extension commands
    users = "search", -- assignee lookup mode
    user_icon = " ", -- user icon
    ghost_icon = "󰊠 ", -- ghost icon
    timeline_marker = " ", -- timeline marker
    timeline_indent = 2, -- timeline indent width
    right_bubble_delimiter = "", -- bubble delimiter
    left_bubble_delimiter = "", -- bubble delimiter
    github_hostname = "", -- github enterprise host
    snippet_context_lines = 4, -- lines around comments in snippets
    gh_cmd = "gh", -- github cli executable
    gh_env = {}, -- github cli environment overrides
    timeout = 5000, -- request timeout
    default_to_projects_v2 = false, -- default to projects v2 for cards
    ui = {
      use_signcolumn = false, -- show modified marks in signcolumn
      use_signstatus = true, -- show modified marks in status column
    },
    issues = {
      order_by = {
        field = "CREATED_AT", -- COMMENTS | CREATED_AT | UPDATED_AT
        direction = "DESC", -- DESC | ASC
      },
    },
    reviews = {
      auto_show_threads = true, -- automatically show comment threads
      focus = "right", -- focus right buffer on diff open
    },
    runs = {
      icons = {
        pending = "🕖",
        in_progress = "🔄",
        failed = "❌",
        succeeded = "",
        skipped = "⏩",
        cancelled = "✖",
      },
    },
    pull_requests = {
      order_by = {
        field = "CREATED_AT", -- COMMENTS | CREATED_AT | UPDATED_AT
        direction = "DESC", -- DESC | ASC
      },
      always_select_remote_on_create = false, -- prompt for base remote repo on create
    },
    notifications = {
      current_repo_only = false, -- show notifications for current repo only
    },
    file_panel = {
      size = 10, -- changed files panel rows
      use_icons = true, -- require nvim-web-devicons for icons
    },
    colors = {
      white = "#ffffff",
      grey = "#2A354C",
      black = "#000000",
      red = "#fdb8c0",
      dark_red = "#da3633",
      green = "#acf2bd",
      dark_green = "#238636",
      yellow = "#d3c846",
      dark_yellow = "#735c0f",
      blue = "#58A6FF",
      dark_blue = "#0366d6",
      purple = "#6f42c1",
      dark_purple = "#271052",
      orange = "#FFA657",
      dark_orange = "#A04100",
    },
    mappings = {
      issue = {
        close_issue = { lhs = "<localleader>ic", desc = "close issue" },
        reopen_issue = { lhs = "<localleader>io", desc = "reopen issue" },
        list_issues = { lhs = "<localleader>il", desc = "list open issues" },
        reload = { lhs = "<C-r>", desc = "reload issue" },
        open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
        copy_url = { lhs = "<C-y>", desc = "copy url" },
        add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
        remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
        create_label = { lhs = "<localleader>lc", desc = "create label" },
        add_label = { lhs = "<localleader>la", desc = "add label" },
        remove_label = { lhs = "<localleader>ld", desc = "remove label" },
        goto_issue = { lhs = "<localleader>gi", desc = "navigate to issue" },
        add_comment = { lhs = "<localleader>ca", desc = "add comment" },
        delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
        next_comment = { lhs = "]c", desc = "next comment" },
        prev_comment = { lhs = "[c", desc = "previous comment" },
        react_hooray = { lhs = "<localleader>rp", desc = "toggle 🎉 reaction" },
        react_heart = { lhs = "<localleader>rh", desc = "toggle ❤️ reaction" },
        react_eyes = { lhs = "<localleader>re", desc = "toggle 👀 reaction" },
        react_thumbs_up = { lhs = "<localleader>r+", desc = "toggle 👍 reaction" },
        react_thumbs_down = { lhs = "<localleader>r-", desc = "toggle 👎 reaction" },
        react_rocket = { lhs = "<localleader>rr", desc = "toggle 🚀 reaction" },
        react_laugh = { lhs = "<localleader>rl", desc = "toggle 😄 reaction" },
        react_confused = { lhs = "<localleader>rc", desc = "toggle 😕 reaction" },
      },
      pull_request = {
        checkout_pr = { lhs = "<localleader>po", desc = "checkout PR" },
        checkout_commit = { lhs = "<localleader>pc", desc = "checkout commit" },
        checkout_branch = { lhs = "<localleader>pb", desc = "checkout branch" },
        merge_pr = { lhs = "<localleader>pm", desc = "merge PR" },
        squash_and_merge_pr = { lhs = "<localleader>psm", desc = "merge PR squashing commits" },
        rebase_and_merge_pr = { lhs = "<localleader>prm", desc = "rebase and merge PR" },
        list_commits = { lhs = "<localleader>pl", desc = "list PR commits" },
        list_changed_files = { lhs = "<localleader>pf", desc = "list PR files" },
        show_pr_diff = { lhs = "<localleader>pd", desc = "show PR diff" },
        add_reviewer = { lhs = "<localleader>va", desc = "add reviewer" },
        remove_reviewer = { lhs = "<localleader>vd", desc = "remove reviewer" },
        close_issue = { lhs = "<localleader>ic", desc = "close PR" },
        reopen_issue = { lhs = "<localleader>io", desc = "reopen PR" },
        list_issues = { lhs = "<localleader>il", desc = "list open issues" },
        reload = { lhs = "<C-r>", desc = "reload PR" },
        open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
        copy_url = { lhs = "<C-y>", desc = "copy url" },
        goto_file = { lhs = "gf", desc = "go to file" },
        add_assignee = { lhs = "<localleader>aa", desc = "add assignee" },
        remove_assignee = { lhs = "<localleader>ad", desc = "remove assignee" },
        create_label = { lhs = "<localleader>lc", desc = "create label" },
        add_label = { lhs = "<localleader>la", desc = "add label" },
        remove_label = { lhs = "<localleader>ld", desc = "remove label" },
        goto_issue = { lhs = "<localleader>gi", desc = "navigate to issue" },
        add_comment = { lhs = "<localleader>ca", desc = "add comment" },
        delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
        next_comment = { lhs = "]c", desc = "next comment" },
        prev_comment = { lhs = "[c", desc = "previous comment" },
        react_hooray = { lhs = "<localleader>rp", desc = "toggle 🎉 reaction" },
        react_heart = { lhs = "<localleader>rh", desc = "toggle ❤️ reaction" },
        react_eyes = { lhs = "<localleader>re", desc = "toggle 👀 reaction" },
        react_thumbs_up = { lhs = "<localleader>r+", desc = "toggle 👍 reaction" },
        react_thumbs_down = { lhs = "<localleader>r-", desc = "toggle 👎 reaction" },
        react_rocket = { lhs = "<localleader>rr", desc = "toggle 🚀 reaction" },
        react_laugh = { lhs = "<localleader>rl", desc = "toggle 😄 reaction" },
        react_confused = { lhs = "<localleader>rc", desc = "toggle 😕 reaction" },
        review_start = { lhs = "<localleader>vs", desc = "start review" },
        review_resume = { lhs = "<localleader>vr", desc = "resume review" },
        review_accept = { lhs = "<localleader>va", desc = "accept review" },
        review_reject = { lhs = "<localleader>vd", desc = "request changes" },
        review_comment = { lhs = "<localleader>vc", desc = "comment review" },
        review_close = { lhs = "<localleader>vx", desc = "close review" },
        review_submit = { lhs = "<localleader>vs", desc = "submit review" },
        review_reopen = { lhs = "<localleader>vo", desc = "reopen review" },
      },
      review_thread = {
        goto_issue = { lhs = "<localleader>gi", desc = "navigate to issue" },
        add_comment = { lhs = "<localleader>ca", desc = "add comment" },
        add_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
        delete_comment = { lhs = "<localleader>cd", desc = "delete comment" },
        next_comment = { lhs = "]c", desc = "next comment" },
        prev_comment = { lhs = "[c", desc = "previous comment" },
        select_next_entry = { lhs = "]q", desc = "next changed file" },
        select_prev_entry = { lhs = "[q", desc = "previous changed file" },
        select_first_entry = { lhs = "[Q", desc = "first changed file" },
        select_last_entry = { lhs = "]Q", desc = "last changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewed state" },
        goto_file = { lhs = "gf", desc = "go to file" },
      },
      submit_win = {
        approve_review = { lhs = "<C-a>", desc = "approve review" },
        comment_review = { lhs = "<C-m>", desc = "comment review" },
        request_changes = { lhs = "<C-r>", desc = "request changes" },
      },
      review_diff = {
        add_review_comment = { lhs = "<localleader>ca", desc = "add comment" },
        add_review_suggestion = { lhs = "<localleader>sa", desc = "add suggestion" },
        focus_files = { lhs = "<localleader>e", desc = "focus files panel" },
        toggle_files = { lhs = "<localleader>b", desc = "toggle files panel" },
        goto_file = { lhs = "gf", desc = "go to file" },
        next_comment = { lhs = "]c", desc = "next comment" },
        prev_comment = { lhs = "[c", desc = "previous comment" },
        select_next_entry = { lhs = "]q", desc = "next changed file" },
        select_prev_entry = { lhs = "[q", desc = "previous changed file" },
        select_first_entry = { lhs = "[Q", desc = "first changed file" },
        select_last_entry = { lhs = "]Q", desc = "last changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewed state" },
        submit_review = { lhs = "<localleader>vs", desc = "submit review" },
        discard_review = { lhs = "<localleader>vd", desc = "discard review" },
      },
      file_panel = {
        submit_review = { lhs = "<localleader>vs", desc = "submit review" },
        discard_review = { lhs = "<localleader>vd", desc = "discard review" },
        next_entry = { lhs = "j", desc = "next changed file" },
        prev_entry = { lhs = "k", desc = "previous changed file" },
        select_entry = { lhs = "<CR>", desc = "show file diff" },
        refresh_files = { lhs = "R", desc = "refresh files" },
        focus_files = { lhs = "<localleader>e", desc = "focus files panel" },
        toggle_files = { lhs = "<localleader>b", desc = "toggle files panel" },
        select_next_entry = { lhs = "]q", desc = "next changed file" },
        select_prev_entry = { lhs = "[q", desc = "previous changed file" },
        select_first_entry = { lhs = "[Q", desc = "first changed file" },
        select_last_entry = { lhs = "]Q", desc = "last changed file" },
        close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        toggle_viewed = { lhs = "<localleader><space>", desc = "toggle viewed state" },
      },
      notification = {
        read = { lhs = "<localleader>rn", desc = "mark notification as read" },
      },
    },
  })

  vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true, desc = "Octo omni complete @" })
  vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true, desc = "Octo omni complete #" })

  vim.g._org_octo_config_loaded = true
end
