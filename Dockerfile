FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build-env
WORKDIR /DockerUniversity

COPY ["DockerUniversity.csproj", "."]
# RUN dotnet restore
RUN dotnet restore "DockerUniversity.csproj"
COPY . .

# Build and publish a release
RUN dotnet build "DockerUniversity.csproj" -c Release -o out
RUN dotnet publish "DockerUniversity.csproj" -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine
WORKDIR /DockerUniversity
COPY --from=build-env /DockerUniversity/out .
COPY CU.db /db/CU.db

EXPOSE 80

ENTRYPOINT ["dotnet", "DockerUniversity.dll"]