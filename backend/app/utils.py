from fastapi import HTTPException, UploadFile, status
from passlib.context import CryptContext


class PasswordsUtils:
    pwd_ctx = CryptContext(schemes=["bcrypt"], deprecated="auto")


def check_extension(
    file: UploadFile, ext_content_type_map: dict[str, list[str]]
) -> str:
    allowed_extensions = list(ext_content_type_map.keys())
    if file.filename is None:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Image should have a filename",
        )

    filename_splitted = file.filename.split(".")

    if len(filename_splitted) < 2:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Image filename should have an extension",
        )

    file_ext = filename_splitted[-1]

    if file_ext not in allowed_extensions:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Image filename extension should be one of: "
            + ", ".join(allowed_extensions),
        )

    if file.content_type not in ext_content_type_map[file_ext]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid content type, got: {file.content_type}, expected: {ext_content_type_map[file_ext]}",
        )

    return file_ext


async def send_email(email: str, token: str) -> None:
    pass