-- ComfySkyEngine Database Schema
-- Version 1.0

-- Model types enumeration
CREATE TABLE IF NOT EXISTS model_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type_name TEXT UNIQUE NOT NULL,
    storage_path TEXT NOT NULL
);

-- Base model architectures
CREATE TABLE IF NOT EXISTS architectures (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    version TEXT,
    base_requirements TEXT
);

-- Main models table
CREATE TABLE IF NOT EXISTS models (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    display_name TEXT,
    architecture_id INTEGER NOT NULL,
    model_type_id INTEGER NOT NULL,
    version TEXT,
    size_mb INTEGER,
    hash_sha256 TEXT,
    description TEXT,
    metadata TEXT,
    is_active INTEGER DEFAULT 1,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (architecture_id) REFERENCES architectures(id),
    FOREIGN KEY (model_type_id) REFERENCES model_types(id),
    UNIQUE(name, version)
);

-- Download sources for models
CREATE TABLE IF NOT EXISTS download_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    model_id INTEGER NOT NULL,
    source_type TEXT NOT NULL,
    source_url TEXT NOT NULL,
    is_primary INTEGER DEFAULT 0,
    requires_auth INTEGER DEFAULT 0,
    mirror_region TEXT,
    FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE
);

-- Model compatibility matrix
CREATE TABLE IF NOT EXISTS model_compatibility (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    child_model_id INTEGER NOT NULL,
    parent_model_id INTEGER,
    parent_architecture_id INTEGER,
    compatibility_notes TEXT,
    FOREIGN KEY (child_model_id) REFERENCES models(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_model_id) REFERENCES models(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_architecture_id) REFERENCES architectures(id),
    CHECK (parent_model_id IS NOT NULL OR parent_architecture_id IS NOT NULL)
);

-- Model dependencies
CREATE TABLE IF NOT EXISTS model_dependencies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    model_id INTEGER NOT NULL,
    requires_model_id INTEGER NOT NULL,
    dependency_type TEXT,
    FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE,
    FOREIGN KEY (requires_model_id) REFERENCES models(id)
);

-- Tags for categorization
CREATE TABLE IF NOT EXISTS tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_name TEXT UNIQUE NOT NULL
);

-- Many-to-many relationship for model tags
CREATE TABLE IF NOT EXISTS model_tags (
    model_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (model_id, tag_id),
    FOREIGN KEY (model_id) REFERENCES models(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- Installed models tracking
CREATE TABLE IF NOT EXISTS installed_models (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    model_id INTEGER NOT NULL,
    install_path TEXT NOT NULL,
    installed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    configuration_id INTEGER,
    status TEXT,
    FOREIGN KEY (model_id) REFERENCES models(id)
);

-- Configurations table
CREATE TABLE IF NOT EXISTS configurations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_default INTEGER DEFAULT 0
);

-- Configuration values
CREATE TABLE IF NOT EXISTS config_values (
    config_id INTEGER,
    key TEXT NOT NULL,
    value TEXT,
    value_type TEXT,
    FOREIGN KEY (config_id) REFERENCES configurations(id) ON DELETE CASCADE,
    PRIMARY KEY (config_id, key)
);

-- Installation history
CREATE TABLE IF NOT EXISTS installations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    config_name TEXT,
    install_path TEXT,
    installed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TEXT,
    log TEXT
);

-- Database version tracking
CREATE TABLE IF NOT EXISTS db_version (
    version INTEGER PRIMARY KEY,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_models_architecture ON models(architecture_id);
CREATE INDEX IF NOT EXISTS idx_models_type ON models(model_type_id);
CREATE INDEX IF NOT EXISTS idx_compatibility_child ON model_compatibility(child_model_id);
CREATE INDEX IF NOT EXISTS idx_compatibility_parent ON model_compatibility(parent_model_id);
CREATE INDEX IF NOT EXISTS idx_sources_model ON download_sources(model_id);
CREATE INDEX IF NOT EXISTS idx_model_tags_model ON model_tags(model_id);
CREATE INDEX IF NOT EXISTS idx_model_tags_tag ON model_tags(tag_id);