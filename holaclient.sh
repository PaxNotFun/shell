#!/bin/bash

# Update and upgrade system packages
apt update
apt upgrade -y

# Create web directory and install Git
mkdir /var/www/
apt install git -y
apt install nano -y
apt install boxes -y
apt install unzip -y
echo "Estamos Instalando Todo Espera Por Favor " | boxes -d peek -a c -s 40x11
echo "Descargando Panel" | boxes -d peek -a c -s 40x1
# Clone HolaClient repository
wget https://github.com/PaxNotFun/shell/raw/main/HolaClient.zip
unzip HolaClient.zip

echo "Configurando Firewall" | boxes -d peek -a c -s 40x1
# Install SSL and Firewall
apt install firewalld -y
firewall-cmd --zone=public --add-port=8080/tcp --permanent 
firewall-cmd --zone=public --add-port=2022/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent 
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload
echo "Configurando SSl" | boxes -d peek -a c -s 40x1
sudo apt install -y python3-certbot-nginx nginx
rm /etc/nginx/sites-enabled/default
certbot certonly --nginx -d portal.cometrakko.com

echo "Instalando dependencias NodeJS y mas" | boxes -d peek -a c -s 40x1
# Install Node.js and dependencies
curl -sL https://deb.nodesource.com/setup_17.x | sudo bash -
apt-get install nodejs gcc g++ make -y

# Navigate to HolaClient directory
cd HolaClient
rm -rf settings.json
echo `{
  "version": "1.5.8",
  "name": "HolaClient",
  "background": "/cdn/background.jpg",
  "banner": "https://media.discordapp.net/attachments/1135147336771850250/1135147435228934176/image.png",
  "defaulttheme": "default",
  "logo": {
    "url": "https://media.discordapp.net/attachments/1082632266506850344/1108449684709703770/image.png",
    "rotate": true,
    "speed": "6s"
  },
  "website": {
    "port": 2000,
    "secret": "Apixelados2_2",
    "hostname": "https://portal.cometrakko.com",
    "description": "The best reliable hosting ever.",
    "language": "en"
  },
  "links": {
    "discord": "https://discord.gg/discord",
    "website": "https://www.cometrakko.com",
    "status": "Online",
    "note": "leave empty to disable!"
  },
  "pterodactyl": {
    "domain": "https://panel.example.com",
    "key": "ptla_",
    "account_key": "ptlc_"
  },
  "features": {
    "news": {
      "enabled": true,
      "content": "Hi, Welcome to CometRakko!"
    },
    "anti_pteroVM": {
      "enabled": true,
      "interval": "30",
      "level": "high",
      "note": "The above value must be in minutes. Available levels: ['low', 'medium', 'high', 'strict']"
    },
    "captcha": {
      "enabled": false,
      "site_key": ""
    },
    "purge": {
      "enabled": false,
      "keyword": "[Active]"
    },
    "status": {
      "enabled": true,
      "show": {
        "nodes": true
      }
    },
    "early_supporters": "100",
    "maintenance": {
      "status": false,
      "admins": [
        "testify@holaclient.tech",
        "863452735998656512",
        "0446",
        "crazymath072"
      ],
      "note": "enter email, Discord ID, HCID or username."
    },
    "subdomain": {
      "enabled": true,
      "note": "requires cloudflare details!"
    },
    "cloudflare": {
      "domain": "cometrakko.com",
      "email": "diegogamerdrh@gmail.com",
      "api_key": "MeMMc9T9WKmnDJjPZxfjUuhD5FgW-iqVrjMRFfsG",
      "zone_id": "0312f50c21d0057b0b8e6eff6fa64fb2",
      "account_id": "f28f13d391747c0344623c6f424d7c51"
    },
    "security": {
      "enabled": true,
      "rate_limiter": true,
      "anti_crawler": true,
      "anti_ddos": true,
      "anti_ddos_cloudflare": true,
      "note": "anti_dddos_cloudflare requires cloudflare details!"
    },
    "smtp": {
      "enabled": true,
      "host": "smtp.elasticemail.com",
      "port": 2525,
      "username": "support@cometrakko",
      "password": "0134D91E4AF35F347C5611307F16DCAF9A11"
    },
    "bot": {
      "enabled": true,
      "token": "MTE5Mzc2MjUxMzk0NzQ3MTg4Mg.GFPDl7.ftJFf6JQgKb470ynhquYhEFq_IWgxnMSZMgbKs",
      "joinguild": {
        "_comment": "Set this to true if you want to make users forcefully join your server.",
        "enabled": true,
        "guildid": [
          "1007506527336276010"
        ]
      }
    },
    "blacklist": {
      "users": [],
      "country": [
        "CN"
      ],
      "note": "enter email, Discord ID, HCID or username in users and country code in country."
    },
    "debug": {
      "enabled": true,
      "log": {
        "admin": true,
        "users": true,
        "startup": false
      }
    }
  },
  "earn": {
    "daily": {
      "enabled": false,
      "coins": "20"
    },
    "linkvertise": {
      "enabled": false,
      "userid": "641981",
      "coins": 5,
      "dailyLimit": "null",
      "minTimeToComplete": "null",
      "timeToExpire": "null",
      "cooldown": "null"
    },
    "shareus": {
      "enabled": false,
      "apiKey": "JtPFh3glixSKXq2oM5fVDX88Snu2",
      "coins": 25,
      "dailyLimit": "null",
      "minTimeToComplete": "null",
      "timeToExpire": "null",
      "cooldown": "null"
    },
    "linkpays": {
      "enabled": false,
      "apiKey": "59d5df2f14b69d49e5a756e7e90696e2a65fe806",
      "coins": 25,
      "dailyLimit": "null",
      "minTimeToComplete": "null",
      "timeToExpire": "null",
      "cooldown": "null"
    },
    "gyanilinks": {
      "enabled": false,
      "apiKey": "f43918a0a673df8c825aba7ddc0dab82aa6087be",
      "coins": 25,
      "dailyLimit": "null",
      "minTimeToComplete": "null",
      "timeToExpire": "null",
      "cooldown": "null"
    },
    "referral": {
      "enabled": false,
      "coins": "50",
      "referred": "25",
      "uses": "9999999999999",
      "note": "Coins: (How much the referrer should get?), referred: (How much should the redeemer get?), uses: (How many times the a referral code can be used?)"
    },
    "j4r": {
      "enabled": false,
      "ads": [
        {
          "name": "HostingConnect",
          "invite": "https://discord.gg/WA4p64Zufq",
          "id": "1061893392503685120",
          "coins": 500
        },
        {
          "name": "HolaClient",
          "invite": "https://discord.gg/CvqRH9TrYK",
          "id": "1038719273658499072",
          "coins": 500
        }
      ]
    },
    "arcio": {
      "enabled": false,
      "widgetid": "none",
      "afk page": {
        "enabled": true,
        "path": "afkwspath",
        "every": 60,
        "coins": 2,
        "_comment4": "By default every 60 seconds you will get 2 coins."
      }
    }
  },
  "ads": {
    "enabled": false,
    "adsense": {
      "enabled": false,
      "clientid": ""
    },
    "ads": [
      {
        "name": "HolaClient",
        "title": "HolaClient",
        "redirect": "https://holaclient.tech",
        "image": "https://media.discordapp.net/attachments/1108054221456146534/1117779127680905226/Untitled.png?width=470&height=110"
      },
      {
        "name": "HolaClient",
        "title": "HolaClient",
        "redirect": "https://holaclient.tech",
        "image": "https://media.discordapp.net/attachments/1108054221456146534/1117779127680905226/Untitled.png?width=470&height=105"
      },
      {
        "name": "HolaClient",
        "title": "HolaClient",
        "redirect": "https://holaclient.tech",
        "image": "https://media.discordapp.net/attachments/1108054221456146534/1117779127680905226/Untitled.png?width=470&height=105"
      },
      {
        "name": "HolaClient",
        "title": "HolaClient",
        "redirect": "https://holaclient.tech",
        "image": "https://media.discordapp.net/attachments/1108054221456146534/1117779127680905226/Untitled.png?width=470&height=105"
      },
      {
        "name": "HolaClient",
        "title": "HolaClient",
        "redirect": "https://holaclient.tech",
        "image": "https://media.discordapp.net/attachments/1108054221456146534/1117779127680905226/Untitled.png?width=470&height=220"
      },
      {
        "name": "HolaClient",
        "title": "HolaClient",
        "redirect": "https://discord.gg/nexorion",
        "image": "https://media.discordapp.net/attachments/1135147336771850250/1135462020246945832/image.png?width=1440&height=320"
      }
    ]
  },
  "api": {
    "enabled": false,
    "key": "GENERATE",
    "client": {
      "enabled": true,
      "locations": {}
    }
  },
  "passwordgenerator": {
    "length": 8
  },
  "allow": {
    "signup": true,
    "newusers": true,
    "regen": true,
    "gift": {
      "status": true,
      "resources": true,
      "coins": true
    },
    "request": {
      "status": true,
      "coins": {
        "status": true,
        "limit": "400",
        "dailyLimit": "200",
        "note": "dailyLimit is the total limit of requests for an account."
      }
    },
    "overresourcessuspend": false,
    "server": {
      "create": true,
      "modify": true,
      "delete": true,
      "cost": "0",
      "note": "cost is the creation cost, Set it to 0 for free creation."
    },
    "renewals": {
      "status": false,
      "cost": 0,
      "delay": 14,
      "suspended": true,
      "note": "delay is in days."
    }
  },
  "authentication": {
    "discord": {
      "id": "1193762513947471882",
      "secret": "v2yQcOSHmIXe72Av7MqDDVlJYhcoNw3z",
      "link": "https://portal.cometrakko.com",
      "callbackpath": "/callback",
      "_comment3": "do not change callbackpath unless you know what you're doing!",
      "prompt": true,
      "verified": true,
      "ip": {
        "trust x-forwarded-for": true,
        "block": [],
        "duplicate check": true
      }
    },
    "email": {
      "enabled": true,
      "ip": {
        "trust x-forwarded-for": true,
        "block": [],
        "duplicate check": true
      }
    }
  },
  "packages": {
    "default": "Default",
    "currency": "USD",
    "symbol": "$",
    "list": {
      "default": {
        "name": "Free",
        "ram": 512,
        "disk": 1024,
        "cpu": 100,
        "servers": 1,
        "databases": 0,
        "backups": 0,
        "allocations": 1
      },
	"minecraft": {
        "name": "Minecraft",
        "ram": 2048,
        "disk": 2048,
        "cpu": 100,
        "servers": 1,
        "databases": 0,
        "backups": 0,
        "allocations": 1
      },
      "invalid": {
        "name": "invalid",
        "ram": 10240,
        "disk": 102400,
        "cpu": 1000,
        "servers": 1,
        "databases": 1,
        "backups": 1,
        "allocations": 2
      }
    },
    "rolePackages": {
      "roleServer": "1009298444805996545",
      "roles": {
        "Role ID": "minecraft"
      },
      "note": "The bot needs to be in that server for this feature to work!"
    }
  },
  "coins": {
    "enabled": true,
    "store": {
      "enabled": true,
      "plans": {
        "invalid": "100",
        "plan name": "plan cost || Not available in this version."
      },
      "ram": {
        "cost": 4000,
        "per": 1
      },
      "disk": {
        "cost": 2000,
        "per": 1
      },
      "cpu": {
        "cost": 8000,
        "per": 1
      },
      "servers": {
        "cost": 5000,
        "per": 1
      },
      "databases": {
        "cost": 3000,
        "per": 1
      },
      "allocations": {
        "cost": 3000,
        "per": 1
      },
      "backups": {
        "cost": 3000,
        "per": 1
      }
    },
    "blackmart": {
      "enabled": true,
      "ram": {
        "cost": 4000,
        "per": 1
      },
      "disk": {
        "cost": 2000,
        "per": 1
      },
      "cpu": {
        "cost": 8000,
        "per": 1
      },
      "servers": {
        "cost": 5000,
        "per": 1
      },
      "databases": {
        "cost": 30000,
        "per": 1
      },
      "allocations": {
        "cost": 3000,
        "per": 1
      },
      "backups": {
        "cost": 2000,
        "per": 1
      }
    }
  },
  "webhook": {
    "status": false,
    "client": "",
    "admin": "",
    "actions": {
      "user": {
        "status": true
      },
      "admin": {
        "set coins": true,
        "add coins": true,
        "remove coins": true,
        "set resources": true,
        "remove resources": true,
        "add resources": true,
        "set plan": true,
        "create coupon": true,
        "revoke coupon": true,
        "remove account": true,
        "view ip": true,
        "signup": true,
        "created server": true,
        "gifted coins": true,
        "modify server": true,
        "bought servers": true,
        "bought ram": true,
        "bought cpu": true,
        "bought disk": true,
        "bought allocations": true,
        "bought databases": true,
        "bought backups": true,
        "sold servers": true,
        "sold ram": true,
        "sold cpu": true,
        "sold disk": true,
        "sold allocations": true,
        "sold databases": true,
        "sold backups": true
      }
    }
  },
  "ratelimits": {
    "global": {
      "max": "400",
      "time": "60",
      "note": "Time is in minutes"
    },
    "API": {}
  }
}` | sudo tee /home/ubuntu/HolaClient/settings.json

# Install Yarn
sudo apt-get update
sudo apt-get install yarn -y

# Install npm dependencies
npm i

# Install pm2 globally
npm i -g pm2

# Start HolaClient with pm2
pm2 start --name "holaclient" index.js

# Configure pm2 to start on system boot
pm2 startup
pm2 save

echo "Configurando NGINX" | boxes -d peek -a c -s 40x1
# Create or edit the Nginx configuration file for HolaClient
echo "server {
    listen 80;
    server_name portal.cometrakko.com;
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;

    location /afkwspath {
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_pass \"http://68.233.127.117:2000/afkwspath\";
    }

    server_name portal.cometrakko.com;
    ssl_certificate /etc/letsencrypt/live/portal.cometrakko.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/portal.cometrakko.com/privkey.pem;
    ssl_session_cache shared:SSL:10m;
    ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://68.233.127.117:2000/;
        proxy_buffering off;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}" | sudo tee /etc/nginx/sites-enabled/holaclient.conf
sudo nginx -t
sudo systemctl reload nginx
