/**
 * @file 団体情報の抽出
 */
import { reduxForm } from 'redux-form';

// 共通コンポーネント
import ReportForm from '../../containers/report/ReportForm';

// ページタイトル
const TITLE = '団体情報の抽出';

// 初期値の設定
const initialValues = {
  // ファイル名
  fileName: 'datOrgList.csv',
  // CSVの値をダブルクォーテーションで囲む
  addQuotes: 1,
};

// フォーム名
const formName = 'OrganizationCsvForm';

// redux-formでstate管理するようにする
export default reduxForm({
  form: formName,
  initialValues,
})(ReportForm(null, TITLE, 'organizationcsv'));
