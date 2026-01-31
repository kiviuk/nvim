return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    local conf = {
      -- Read API key from environment variable
      -- Set OPENROUTER_API_KEY in your shell config (e.g., .zshrc or .bashrc)
      providers = {
        -- Disable default OpenAI provider
        openai = {
          disable = true,
        },
        -- Configure OpenRouter
        openrouter = {
          endpoint = "https://openrouter.ai/api/v1/chat/completions",
          secret = { "cat", vim.fn.expand("~/bin/OR_TOKEN.txt") },
        },
      },
      
      -- Custom agents for OpenRouter models
      agents = {
        -- Claude 3.5 Sonnet (chat)
        {
          provider = "openrouter",
          name = "ChatClaude",
          chat = true,
          command = false,
          model = { model = "anthropic/claude-3.5-sonnet", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        -- GPT-4o (chat)
        {
          provider = "openrouter",
          name = "ChatGPT4o",
          chat = true,
          command = false,
          model = { model = "openai/gpt-4o", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        -- DeepSeek R1 (chat)
        {
          provider = "openrouter",
          name = "ChatDeepSeek",
          chat = true,
          command = false,
          model = { model = "deepseek/deepseek-r1", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        -- Claude 3.5 Sonnet (code)
        {
          provider = "openrouter",
          name = "CodeClaude",
          chat = false,
          command = true,
          model = { model = "anthropic/claude-3.5-sonnet", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        -- GPT-4o (code)
        {
          provider = "openrouter",
          name = "CodeGPT4o",
          chat = false,
          command = true,
          model = { model = "openai/gpt-4o", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        -- DeepSeek R1 (code)
        {
          provider = "openrouter",
          name = "CodeDeepSeek",
          chat = false,
          command = true,
          model = { model = "deepseek/deepseek-r1", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
      },
      
      -- Default chat agent
      default_chat_agent = "ChatClaude",
      -- Default command agent
      default_command_agent = "CodeClaude",
      
      -- UI settings
      toggle_target = "vsplit",
      style_popup_border = "rounded",
      style_chat_finder_border = "rounded",
      
      -- Directory for chat files
      chat_dir = vim.fn.stdpath("data"):gsub("/$", "") .. "/gp/chats",
    }
    
    require("gp").setup(conf)
  end,
}
