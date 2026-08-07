#ai-chat.nix
{
  ...
}:
{
  programs.aichat = {
    enable = true;
    settings = {
      model = "local:qwen2.5-coder";
      clients = [
        {
          type = "openai-compatible";
          name = "local";
          api_base = "http://127.0.0.1:8012/v1";
          api_key = "not-needed";
          models = [
            {
              name = "qwen2.5-coder";
              max_input_tokens = 32768;
            }
          ];
        }
      ];
    };
  };
}
