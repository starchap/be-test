#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim-arm32v7 AS base
COPY ./bin/Release/net5.0/. /app/
ENTRYPOINT ["dotnet", "app.dll"]
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["be-test/be-test/be-test.csproj", "be-test/"]
RUN dotnet restore "be-test/be-test.csproj"
COPY . .
WORKDIR "/src/be-test"
RUN dotnet build "be-test/be-test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "be-test/be-test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "be-test.dll"]