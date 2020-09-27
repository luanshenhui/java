import React from 'react';
import styled from 'styled-components';

import OrgGuide from './guide/OrgGuide';
import PersonGuide from './guide/PersonGuide';
import UserGuide from './guide/UserGuide';
import RslCmtGuide from './guide/RslCmtGuide';
import SecondLineDivGuide from './guide/SecondLineDivGuide';
import AdviceComment from './guide/AdviceComment';
import ItemAndGroupGuide from './guide/ItemAndGroupGuide';
import SentenceGuide from './guide/SentenceGuide';

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

const ExampleForm = () => (
  <div>
    <Caption>団体ガイド</Caption>
    <OrgGuide />
    <Caption>個人ガイド</Caption>
    <PersonGuide />
    <Caption>利用者ガイド</Caption>
    <UserGuide />
    <Caption>結果コメントガイド</Caption>
    <RslCmtGuide />
    <Caption>2次検査請求明細ガイド</Caption>
    <SecondLineDivGuide />
    <Caption>生活指導、食習慣、献立コメントの選択</Caption>
    <AdviceComment />
    <Caption>項目ガイド</Caption>
    <ItemAndGroupGuide />
    <Caption>文章ガイド</Caption>
    <SentenceGuide />
  </div>
);

export default ExampleForm;
