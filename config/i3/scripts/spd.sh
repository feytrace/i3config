if [ $1 == s ]; then
  pd=$(pwd)
  echo "pd set to"
  echo $pd
else
  cd $pd
fi
