#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:2.1.27-bionic-arm32v7 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:2.1.815-bionic-arm32v7 AS build
WORKDIR /src
COPY ["be-test/be-test.csproj", "be-test/"]
RUN dotnet restore "be-test/be-test.csproj"
COPY . .
WORKDIR "/src/be-test"
RUN dotnet build "be-test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "be-test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "be-test.dll"]