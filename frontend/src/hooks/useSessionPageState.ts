import { useEffect, useMemo, useRef, useState } from 'react';
import { useRouter } from 'next/router';

const STORAGE_PREFIX = 'ui-session-page-state:v1';
const TOKEN_KEY = 'auth_token';

const getUserScope = () => {
  if (typeof window === 'undefined') return 'anon';
  const token = localStorage.getItem(TOKEN_KEY) || '';
  return token ? token.slice(0, 16) : 'anon';
};

const buildStorageKey = (pathname: string, stateKey: string) =>
  `${STORAGE_PREFIX}:${getUserScope()}:${pathname}:${stateKey}`;

const readStoredValue = <T,>(storageKey: string, fallback: T): T => {
  if (typeof window === 'undefined') return fallback;

  try {
    const raw = sessionStorage.getItem(storageKey);
    if (raw == null) return fallback;
    return JSON.parse(raw) as T;
  } catch {
    return fallback;
  }
};

export const clearSessionPageState = () => {
  if (typeof window === 'undefined') return;

  try {
    const keysToRemove: string[] = [];
    for (let i = 0; i < sessionStorage.length; i += 1) {
      const key = sessionStorage.key(i);
      if (key && key.startsWith(`${STORAGE_PREFIX}:`)) {
        keysToRemove.push(key);
      }
    }
    keysToRemove.forEach((key) => sessionStorage.removeItem(key));
  } catch {
    // no-op on storage errors
  }
};

export const useSessionPageState = <T,>(stateKey: string, fallback: T) => {
  const router = useRouter();
  const fallbackRef = useRef(fallback);

  const storageKey = useMemo(() => {
    const pathname = router.pathname || 'unknown';
    return buildStorageKey(pathname, stateKey);
  }, [router.pathname, stateKey]);

  const [value, setValue] = useState<T>(() =>
    readStoredValue(storageKey, fallbackRef.current),
  );

  useEffect(() => {
    setValue(readStoredValue(storageKey, fallbackRef.current));
  }, [storageKey]);

  useEffect(() => {
    if (typeof window === 'undefined') return;
    try {
      sessionStorage.setItem(storageKey, JSON.stringify(value));
    } catch {
      // no-op on storage errors
    }
  }, [storageKey, value]);

  return [value, setValue] as const;
};
