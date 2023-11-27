from datetime import datetime
from typing import Any

from feast.protos.feast.types.Value_pb2 import Value
from pytz import utc


def make_tzaware(t: datetime) -> datetime:
    """We assume tz-naive datetimes are UTC"""
    if t.tzinfo is None:
        return t.replace(tzinfo=utc)
    else:
        return t


# Hacking this together at the moment.
def to_proto_value(value: Any) -> Value:
    if isinstance(value, int):
        return Value(int64_val=value)
    elif isinstance(value, float):
        return Value(double_val=value)
    elif isinstance(value, str):
        return Value(string_val=value)
    else:
        raise TypeError(f"Unsupported data type: {type(value)}")
