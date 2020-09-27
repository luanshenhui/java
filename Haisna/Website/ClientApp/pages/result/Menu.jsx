import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

import MenuItem from '../../components/MenuItem';
import PageLayout from '../../layouts/PageLayout';
import RslMenu from '../../containers/result/RslMenu';

const Wrapper = styled.div`
 font-size: 16px;
 margin-left: 80px;
 padding-bottom:18px;
 padding-left:25px;
`;

const Menu = () => (
  <PageLayout title="結果入力">
    <MenuItem
      title="結果入力"
      description="受診者毎の検査結果を入力します。問診結果入力もこちらからどうぞ"
      image=""
    />
    <Wrapper>
      <RslMenu />
    </Wrapper>
    <MenuItem
      title="検査結果を一括して入力"
      link="/contents/result/rslAllSet"
      description="正常判定などの定型検査結果を複数受診者に一括して入力します。"
      image=""
    />
    <MenuItem
      title="ワークシート形式の結果入力"
      link="/contents/result/rslListSet"
      description="分析器から出力された検査結果リスト、定期健康診断などのある範囲の検査結果を複数受診者に対して入力する場合に便利です。"
      image=""
    />
    <MenuItem
      title="進捗状況の確認"
      link="/contents/result/progress"
      description="現在の検査進捗状況を表示します。"
      image=""
    />
  </PageLayout>
);

export default Menu;
