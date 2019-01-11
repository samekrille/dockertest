FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
# Required project structure:
# -X.sln
# -src
# --A
# ---A.csproj
# -test
# --B
# ---B.csproj

WORKDIR /sln
COPY *.sln .

# Copy src project files
COPY src/*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p src/${file%.*}/ && mv $file src/${file%.*}/; done

# Copy test project files
COPY test/*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p test/${file%.*}/ && mv $file test/${file%.*}/; done

RUN dotnet restore

COPY . .
WORKDIR /sln
RUN dotnet build -c Release --no-restore

FROM build as test
WORKDIR /sln
ENTRYPOINT ["dotnet", "test", "--logger:trx", "--no-build", "-c:Release", "--results-directory:/TestResults/"]

FROM test AS publish
WORKDIR /sln/src/DockerTest
RUN dotnet publish DockerTest.csproj -c Release -o /app --no-build

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerTest.dll"]
