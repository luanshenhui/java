// @flow

import * as React from 'react';

// Action Creator、Stateタイプ定義のインポート
import { type StateSentence } from '../../../types/common/sentenceGuide';

import Table from '../../../components/Table';

// cssのインポート
import styles from './SentenceList.css';

// コンポーネントの定義
const SentenceList = ({ sentences, onSelect }: { sentences: Array<StateSentence>, onSelect: ?Function }) => (
  <Table className={styles.sentenceList}>
    <thead>
      <tr>
        <th className={styles.stcCd}>コード</th>
        <th className={styles.shortStc}>文章名</th>
      </tr>
    </thead>
    <tbody>
      {sentences.map((rec) => (
        <tr key={rec.stcCd} onClick={() => onSelect && onSelect(rec.stcCd)}>
          <td className={styles.stcCd}>{rec.stcCd}</td>
          <td className={styles.shortStc}>{rec.shortStc}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

export default SentenceList;
