from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    GEMINI_API_KEY: str
    GEMINI_MODEL: str = "gemini-3.1-flash-lite-preview"
    APP_TITLE: str = "Chatbot SRE"
    APP_VERSION: str = "1.0.0"
    CORS_ORIGINS: str = "*"


settings = Settings()
