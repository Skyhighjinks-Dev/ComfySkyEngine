-- ComfySkyEngine Seed Data
-- Version 1.0

-- Insert database version
INSERT OR IGNORE INTO db_version (version) VALUES (1);

-- Model Types
INSERT OR IGNORE INTO model_types (type_name, storage_path) VALUES 
    ('checkpoint', 'models/checkpoints'),
    ('lora', 'models/loras'),
    ('vae', 'models/vae'),
    ('text_encoder', 'models/clip'),
    ('unet', 'models/unet'),
    ('controlnet', 'models/controlnet'),
    ('embedding', 'models/embeddings');

-- Architectures
INSERT OR IGNORE INTO architectures (name, version, base_requirements) VALUES 
    ('FLUX', '1.0', '{"min_vram": 24, "python_version": "3.10"}'),
    ('SDXL', '1.0', '{"min_vram": 10, "python_version": "3.10"}'),
    ('SD', '1.5', '{"min_vram": 6, "python_version": "3.10"}'),
    ('SD', '2.1', '{"min_vram": 8, "python_version": "3.10"}'),
    ('WAN', '2.2', '{"min_vram": 12, "python_version": "3.10"}'),
    ('Pony', '6.0', '{"min_vram": 10, "python_version": "3.10"}');

-- Tags
INSERT OR IGNORE INTO tags (tag_name) VALUES 
    ('photorealistic'),
    ('anime'),
    ('artistic'),
    ('landscape'),
    ('portrait'),
    ('nsfw'),
    ('sfw'),
    ('base-model'),
    ('fine-tune'),
    ('merge');

-- Sample Models - FLUX
INSERT OR IGNORE INTO models (name, display_name, architecture_id, model_type_id, version, size_mb, description) VALUES 
    ('flux1-dev', 'FLUX.1 Dev', 1, 1, '1.0', 23800, 'FLUX.1 Development model with high quality output'),
    ('flux1-schnell', 'FLUX.1 Schnell', 1, 1, '1.0', 23800, 'FLUX.1 Fast model optimized for speed'),
    ('flux1-krea', 'FLUX.1 Krea Dev', 1, 1, '1.0', 23800, 'FLUX.1 Krea variant for creative outputs');

-- Sample Models - SDXL
INSERT OR IGNORE INTO models (name, display_name, architecture_id, model_type_id, version, size_mb, description) VALUES 
    ('dreamshaper-xl', 'DreamShaper XL', 2, 1, '2.0', 6460, 'Versatile SDXL model for various styles'),
    ('realvis-xl', 'RealVis XL', 2, 1, '3.0', 6460, 'Photorealistic SDXL model'),
    ('juggernaut-xl', 'Juggernaut XL', 2, 1, '9.0', 6460, 'High quality photorealistic SDXL model');

-- Sample Models - SD 1.5
INSERT OR IGNORE INTO models (name, display_name, architecture_id, model_type_id, version, size_mb, description) VALUES 
    ('dreamshaper', 'DreamShaper', 3, 1, '8.0', 2132, 'Popular SD 1.5 model for various styles'),
    ('realistic-vision', 'Realistic Vision', 3, 1, '5.1', 2132, 'Photorealistic SD 1.5 model');

-- Sample LoRAs
INSERT OR IGNORE INTO models (name, display_name, architecture_id, model_type_id, version, size_mb, description) VALUES 
    ('detail-tweaker-xl', 'Detail Tweaker XL', 2, 2, '1.0', 200, 'Enhances detail in SDXL models'),
    ('anime-style-xl', 'Anime Style XL', 2, 2, '2.0', 150, 'Anime style LoRA for SDXL'),
    ('add-detail', 'Add Detail', 3, 2, '1.0', 140, 'Detail enhancement for SD 1.5');

-- Sample VAEs
INSERT OR IGNORE INTO models (name, display_name, architecture_id, model_type_id, version, size_mb, description) VALUES 
    ('sdxl-vae', 'SDXL VAE', 2, 3, '1.0', 335, 'Standard VAE for SDXL models'),
    ('vae-ft-mse', 'VAE ft-mse', 3, 3, '1.0', 335, 'Fine-tuned VAE for SD 1.5');

-- Download Sources - HuggingFace examples
INSERT OR IGNORE INTO download_sources (model_id, source_type, source_url, is_primary) VALUES 
    (1, 'huggingface_cli', 'black-forest-labs/FLUX.1-dev/flux1-dev.safetensors', 1),
    (2, 'huggingface_cli', 'black-forest-labs/FLUX.1-schnell/flux1-schnell.safetensors', 1),
    (4, 'huggingface_cli', 'Lykon/DreamShaper/DreamShaperXL_v2.safetensors', 1),
    (5, 'huggingface_cli', 'SG161222/RealVisXL/RealVisXL_V3.0.safetensors', 1);

-- Direct URL examples (for models not on HF)
INSERT OR IGNORE INTO download_sources (model_id, source_type, source_url, is_primary) VALUES 
    (3, 'direct_url', 'https://example.com/models/flux1-krea.safetensors', 1),
    (6, 'civitai', 'https://civitai.com/api/download/models/357609', 1);

-- Model Compatibility - LoRAs work with their architecture
INSERT OR IGNORE INTO model_compatibility (child_model_id, parent_architecture_id, compatibility_notes) VALUES 
    (9, 2, 'Works with any SDXL base model'),
    (10, 2, 'Works with any SDXL base model'),
    (11, 3, 'Works with any SD 1.5 base model');

-- VAE Compatibility
INSERT OR IGNORE INTO model_compatibility (child_model_id, parent_architecture_id, compatibility_notes) VALUES 
    (12, 2, 'Recommended VAE for all SDXL models'),
    (13, 3, 'Recommended VAE for all SD 1.5 models');

-- Model Tags
INSERT OR IGNORE INTO model_tags (model_id, tag_id) VALUES 
    (1, 8), (1, 7),  -- flux1-dev: base-model, sfw
    (2, 8), (2, 7),  -- flux1-schnell: base-model, sfw
    (4, 1), (4, 3), (4, 9),  -- dreamshaper-xl: photorealistic, artistic, fine-tune
    (5, 1), (5, 7),  -- realvis-xl: photorealistic, sfw
    (6, 1), (6, 7),  -- juggernaut-xl: photorealistic, sfw
    (7, 3), (7, 9),  -- dreamshaper: artistic, fine-tune
    (8, 1), (8, 7);  -- realistic-vision: photorealistic, sfw

-- Default Configuration
INSERT OR IGNORE INTO configurations (name, is_default) VALUES 
    ('default', 1),
    ('flux_krea_setup', 0),
    ('sdxl_anime_setup', 0);

-- Sample config values for default configuration
INSERT OR IGNORE INTO config_values (config_id, key, value, value_type) VALUES 
    (1, 'install_path', '', 'string'),
    (1, 'python_version', '3.11', 'string'),
    (1, 'create_venv', 'true', 'bool'),
    (1, 'install_cuda', 'true', 'bool'),
    (1, 'cuda_version', '12.1', 'string');

-- Sample config for flux_krea_setup
INSERT OR IGNORE INTO config_values (config_id, key, value, value_type) VALUES 
    (2, 'install_path', 'C:\\ComfyUI_Flux', 'string'),
    (2, 'python_version', '3.11', 'string'),
    (2, 'create_venv', 'true', 'bool'),
    (2, 'install_cuda', 'true', 'bool'),
    (2, 'cuda_version', '12.1', 'string'),
    (2, 'default_model', 'flux1-krea', 'string');