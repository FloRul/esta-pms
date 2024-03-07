from pydantic import BaseModel, validator
from datetime import date
from typing import Dict
import re


class Template(BaseModel):
    id: str
    version: str
    creation_date: date
    name: str
    url: str
    tags: Dict[str, str]

    @validator("version")
    def validate_version(cls, v):
        # Validate version string major, minor and patch
        pattern = r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
        if not re.match(pattern, v):
            raise ValueError("Invalid version string")
        return v
