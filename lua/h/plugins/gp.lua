return {
  "robitx/gp.nvim",
  cmd = { "GpChat", "GpTask", "GpCmd" },
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
        -- Xiaomi MiMo v2 Flash (chat)
        {
          provider = "openrouter",
          name = "ChatMimo",
          chat = true,
          command = false,
          model = { model = "xiaomi/mimo-v2-flash", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        -- NVIDIA Nemotron 3 Nano 30B (chat) - FREE
        {
          provider = "openrouter",
          name = "ChatNvidia",
          chat = true,
          command = false,
          model = { model = "nvidia/nemotron-3-nano-30b-a3b:free", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        -- Z-AI GLM-4.7 (chat)
        {
          provider = "openrouter",
          name = "ChatGLM",
          chat = true,
          command = false,
          model = { model = "z-ai/glm-4.7", temperature = 0.8, top_p = 1 },
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
        -- DeepSeek V3.2 (chat)
        {
          provider = "openrouter",
          name = "ChatDeepSeekV3",
          chat = true,
          command = false,
          model = { model = "deepseek/deepseek-v3.2", temperature = 0.8, top_p = 1 },
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
        -- Xiaomi MiMo v2 Flash (code)
        {
          provider = "openrouter",
          name = "CodeMimo",
          chat = false,
          command = true,
          model = { model = "xiaomi/mimo-v2-flash", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        -- NVIDIA Nemotron 3 Nano 30B (code) - FREE
        {
          provider = "openrouter",
          name = "CodeNvidia",
          chat = false,
          command = true,
          model = { model = "nvidia/nemotron-3-nano-30b-a3b:free", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        -- Z-AI GLM-4.7 (code)
        {
          provider = "openrouter",
          name = "CodeGLM",
          chat = false,
          command = true,
          model = { model = "z-ai/glm-4.7", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
        -- DeepSeek V3.2 (code)
        {
          provider = "openrouter",
          name = "CodeDeepSeekV3",
          chat = false,
          command = true,
          model = { model = "deepseek/deepseek-v3.2", temperature = 0.7, top_p = 1 },
          system_prompt = require("gp.defaults").code_system_prompt,
        },
      },

      -- Default chat agent (NVIDIA - free model)
      default_chat_agent = "ChatNvidia",
      -- Default command agent (NVIDIA - free model)
      default_command_agent = "CodeNvidia",
      
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
