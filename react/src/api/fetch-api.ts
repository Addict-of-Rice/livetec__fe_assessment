const API_BASE_URL = 'http://localhost:3000';

export const fetchApi = async <T>(
  method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE' = 'GET',
  path: string,
  // token?: string,
  query?: Record<string, any>,
  body?: any
): Promise<T> => {
  try {
    let url = `${API_BASE_URL}${path}`;
    if (query && Object.keys(query).length > 0) {
      const queryString = new URLSearchParams(
        Object.entries(query)
          .filter(([_, v]) => v !== undefined)
          .map(([k, v]) => [k, String(v)])
      ).toString();
      url += `?${queryString}`;
    }

    const response: Response = await fetch(url, {
      method: method,
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        // ...(token && { Authorization: `Bearer ${token}` }),
      },
      body: body ? JSON.stringify(body) : undefined,
    });

    if (!response.ok) {
      throw new Error(`${response.status} - ${response.statusText}`);
    }

    return response.json() as Promise<T>;
  } catch (e: unknown) {
    // toast.error(String(e), { toastId: `${method} ${path}` });
    console.error(e);
    return Promise.reject(e instanceof Error ? e : new Error(String(e)));
  }
};
