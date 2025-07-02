#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Helper functions for safe config.ini parsing
"""

import configparser
import os

def get_safe_config_value(config, section, key, default=None):
    """
    Safely get config value, removing comments and whitespace
    
    Args:
        config: ConfigParser instance
        section: Section name
        key: Key name
        default: Default value if not found
        
    Returns:
        Clean config value
    """
    try:
        value = config.get(section, key)
        # Remove inline comments and whitespace
        value = value.split('#')[0].strip()
        return value
    except (configparser.NoSectionError, configparser.NoOptionError):
        return default

def get_safe_config_int(config, section, key, default=0):
    """
    Safely get config value as integer
    
    Args:
        config: ConfigParser instance
        section: Section name  
        key: Key name
        default: Default value if not found or invalid
        
    Returns:
        Integer value
    """
    try:
        value = get_safe_config_value(config, section, key)
        if value is None:
            return default
        return int(value)
    except (ValueError, TypeError):
        return default

def load_config(config_path="config.ini"):
    """
    Load and return config with safe parsing
    
    Args:
        config_path: Path to config file
        
    Returns:
        ConfigParser instance
    """
    config = configparser.ConfigParser(
        empty_lines_in_values=False, 
        allow_no_value=True,
        inline_comment_prefixes=('#', ';')
    )
    
    if os.path.exists(config_path):
        config.read(config_path, encoding='utf-8')
    
    return config