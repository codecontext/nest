from datetime import date

from fastapi.testclient import TestClient

from backend.app.main import app


client = TestClient(app)


def test_get_available_rooms_for_hotel():
    response = client.get(
        '/hotels/1/availability',
        params={'check_in': '2026-10-18', 'check_out': '2026-10-20'},
    )

    assert response.status_code == 200
    payload = response.json()
    assert isinstance(payload, list)
    assert payload
    assert payload[0]['hotel_id'] == 1
