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
ENTRYPOINT ["dotnet", "test", "--logger:trx", "--no-restore", "--results-directory:/TestResults/"]

FROM test AS publish
WORKDIR /src/DockerTest
RUN dotnet publish DockerTest.csproj -c Release -o /app --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerTest.dll"]
