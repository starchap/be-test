#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1.14-bionic-arm32v7 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 44303

FROM mcr.microsoft.com/dotnet/sdk:3.1.408-bionic-arm32v7 AS build
WORKDIR /src
COPY ["be-test.csproj", "."]
RUN dotnet restore "./be-test.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "be-test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "be-test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "be-test.dll"]