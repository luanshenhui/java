// @flow

import * as React from 'react';
import Helmet from 'react-helmet';

// コンポーネントのインポート
import TitleBar from '../components/TitleBar';

// cssのインポート
import styles from './PageLayout.css';

// Propsの定義
type Props = {
  children: React.Node,
  title: string,
};

// コンポーネントの定義
const PageLayout = ({ children, title }: Props) => (
  <div className={styles.pageLayout}>
    <Helmet>
      <title>{title}</title>
    </Helmet>
    <TitleBar type="maintenance">{title}</TitleBar>
    <div className={styles.contents}>
      {children}
    </div>
  </div>
);

export default PageLayout;
