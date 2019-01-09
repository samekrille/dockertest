FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY *.sln .
COPY DockerTest/DockerTest.csproj DockerTest/
COPY Business/Business.csproj Business/
COPY Business.Test/Business.Test.csproj Business.Test/
RUN dotnet restore
COPY . .
WORKDIR /src/DockerTest
RUN dotnet build DockerTest.csproj -c Release -o /app --no-restore

FROM build as test
WORKDIR /src
RUN mkdir /testresult
RUN dotnet test --logger "trx;LogFileName=TestResult.trx" --no-restore; \
	echo $? > /testresult/passorfail

FROM test AS publish
RUN testresult=$(cat /testresult/passorfail);if [ 0 -eq $testresult ]; then echo "Tests passed, continuing" >&2; else echo "Tests failed, aborting build" >&2; exit 1 >&2; fi
WORKDIR /src/DockerTest
RUN dotnet publish DockerTest.csproj -c Release -o /app --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerTest.dll"]
