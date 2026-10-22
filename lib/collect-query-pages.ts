/** Keep every page; a failed read must never masquerade as complete history. */
export async function collectQueryPages<T>(size: number, read: (from: number, to: number) => PromiseLike<{
    data: T[] | null;
    error: unknown;
}>, errorMessage: string): Promise<T[]> {
    const rows: T[] = [];
    for (let from = 0;; from += size) {
        const { data, error } = await read(from, from + size - 1);
        if (error)
            throw new Error(errorMessage);
        rows.push(...(data ?? []));
        if (!data || data.length < size)
            return rows;
    }
}
