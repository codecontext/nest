from fastapi.testclient import TestClient

from backend.app.main import app


client = TestClient(app)


def test_get_rooms_by_hotel():
    response = client.get('/hotels/1/rooms')

    assert response.status_code == 200
    payload = response.json()
    assert isinstance(payload, list)
    assert payload
    assert payload[0]['hotel_id'] == 1
