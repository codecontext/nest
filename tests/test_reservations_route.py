from fastapi.testclient import TestClient

from backend.app.main import app


client = TestClient(app)


def test_get_user_reservations():
    response = client.get('/users/1/reservations')

    assert response.status_code == 200
    payload = response.json()
    assert isinstance(payload, list)
    assert payload
    assert payload[0]['hotel_id'] == 1
