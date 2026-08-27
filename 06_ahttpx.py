import asyncio, httpx

async def fetch(client, url, sem) -> str:
    async with sem:
        print('요청 시작', url)
        r = await client.get(url)
        print('요청 끝', url)
        r.raise_for_status()
        return (url, 'ok')

async def main():
    urls = [url.rstrip() for url in open('./urls.txt').readlines()]

    # limits = httpx.Limits(max_connections=3)
    sem = asyncio.Semaphore(3)
    # limits=limits
    async with httpx.AsyncClient(timeout=10) as client:
        tasks = [fetch(client, url, sem) for url in urls] # 13개
        results = await asyncio.gather(*tasks, return_exceptions=True)
        # ['응답 O', Exception(), ]
    
    print(results)

    for result in results:
        if type(result) == str:
            # 응답 O
            ...
        else:
            # 오류 처리
            ...

    # print('비동기 함수 main')
    # await asyncio.sleep(3) # await
    # print('3초 뒤 실행?')

if __name__ == '__main__':
    asyncio.run(main())