'use client';

import { FormEvent, useEffect, useMemo, useRef, useState } from 'react';
import { useRouter } from 'next/router';
import Layout from '../components/Layout';
import { apiClient } from '../lib/api';
import styles from '../styles/financeiro-diario.module.css';

interface Restaurante {
  restID: number;
  name: string;
}

interface User {
  id: number;
  name: string;
  email: string;
  role: string;
  restaurantes: { restID: number }[];
}

const ALLOWED_ROLES = ['ADMIN', 'SUPER_ADMIN'];

const roleLabel: Record<string, string> = {
  SUPER_ADMIN: 'Super Administrador',
  ADMIN: 'Administrador',
  SUPERVISOR: 'Supervisor',
  GERENTE: 'Gerente',
};

export default function Usuarios() {
  const router = useRouter();
  const [authorized, setAuthorized] = useState<boolean | null>(null);
  const [sessionRole, setSessionRole] = useState<string>('');
  const [sessionUserId, setSessionUserId] = useState<number | null>(null);
  const [users, setUsers] = useState<User[]>([]);
  const [restaurantes, setRestaurantes] = useState<Restaurante[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [selectedRests, setSelectedRests] = useState<number[]>([]);
  const [role, setRole] = useState('GERENTE');
  const [deletingUserId, setDeletingUserId] = useState<number | null>(null);
  const [adminName, setAdminName] = useState('');
  const [adminEmail, setAdminEmail] = useState('');
  const [adminPassword, setAdminPassword] = useState('');
  const [adminPasswordConfirm, setAdminPasswordConfirm] = useState('');
  const [creatingAdmin, setCreatingAdmin] = useState(false);
  const [newPassword, setNewPassword] = useState('');
  const [newPasswordConfirm, setNewPasswordConfirm] = useState('');
  const [resettingPassword, setResettingPassword] = useState(false);
  const editorRef = useRef<HTMLDivElement | null>(null);

  const roleOptions = useMemo(
    () =>
      sessionRole === 'SUPER_ADMIN'
        ? ['GERENTE', 'SUPERVISOR', 'ADMIN']
        : ['GERENTE', 'SUPERVISOR'],
    [sessionRole],
  );

  const canEditTarget = (target: User | null) => {
    if (!target) return false;
    if (sessionUserId === target.id) return false;
    if (sessionRole === 'SUPER_ADMIN') return true;
    if (sessionRole === 'ADMIN') {
      return target.role !== 'ADMIN' && target.role !== 'SUPER_ADMIN';
    }
    return false;
  };

  const refreshUsers = async () => {
    const refreshed = await apiClient.getUsers();
    const refreshedUsers: User[] = refreshed.data || [];
    setUsers(refreshedUsers);
    return refreshedUsers;
  };

  useEffect(() => {
    const bootstrap = async () => {
      try {
        setLoading(true);
        setError('');

        const token =
          typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;
        if (!token) {
          router.replace('/login');
          return;
        }

        const me = await apiClient.me();
        const currentRole = String(me.data?.role || '');
        const currentId = Number(me.data?.id || 0) || null;

        if (!ALLOWED_ROLES.includes(currentRole)) {
          router.replace('/');
          return;
        }

        setAuthorized(true);
        const [usersRes, restRes] = await Promise.all([
          apiClient.getUsers(),
          apiClient.getRestaurantes(true),
        ]);

        setSessionRole(currentRole);
        setSessionUserId(currentId);
        setUsers(usersRes.data || []);
        setRestaurantes(restRes.data || []);
      } catch (err: any) {
        const status = err?.response?.status;
        if (status === 401) {
          router.replace('/login');
          return;
        }
        if (status === 403) {
          router.replace('/');
          return;
        }
        const msg = err?.response?.data?.message || 'Erro ao carregar usuários';
        setError(msg);
        setAuthorized(true);
      } finally {
        setLoading(false);
      }
    };

    bootstrap();
  }, [router]);

  const handleSelectUser = (user: User) => {
    if (!canEditTarget(user)) {
      setError('Você não tem permissão para editar este usuário.');
      setSuccess('');
      return;
    }

    setSelectedUser(user);
    setSelectedRests(user.restaurantes?.map((r) => r.restID) || []);
    if (user.role === 'SUPER_ADMIN') {
      setRole('GERENTE');
    } else {
      setRole(user.role);
    }
    setSuccess('');
    setError('');
    setNewPassword('');
    setNewPasswordConfirm('');

    if (typeof window !== 'undefined') {
      window.requestAnimationFrame(() => {
        editorRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' });
      });
    }
  };

  const toggleRest = (restID: number) => {
    setSelectedRests((prev) =>
      prev.includes(restID) ? prev.filter((id) => id !== restID) : [...prev, restID],
    );
  };

  const handleSave = async () => {
    if (!selectedUser) return;
    if (!canEditTarget(selectedUser)) {
      setError('Você não tem permissão para editar este usuário.');
      return;
    }

    try {
      setLoading(true);
      setError('');
      setSuccess('');

      await apiClient.updateUserRole(selectedUser.id, role);
      if (role !== 'ADMIN') {
        await apiClient.setUserRestaurants(selectedUser.id, selectedRests);
      }

      const refreshedUsers = await refreshUsers();
      const updated = refreshedUsers.find((u) => u.id === selectedUser.id) || null;
      setSelectedUser(updated);
      setSelectedRests(updated?.restaurantes?.map((r) => r.restID) || []);
      setRole(updated?.role && roleOptions.includes(updated.role) ? updated.role : 'GERENTE');
      setSuccess('Usuário atualizado com sucesso.');
    } catch (err: any) {
      const msg = err?.response?.data?.message || 'Erro ao salvar usuário';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteUser = async (target: User) => {
    if (!canEditTarget(target)) {
      setError('Você não tem permissão para remover este usuário.');
      return;
    }

    const confirmed = window.confirm(
      `Deseja realmente remover o usuário "${target.name}"? Esta ação não pode ser desfeita.`,
    );
    if (!confirmed) return;

    try {
      setDeletingUserId(target.id);
      setError('');
      setSuccess('');

      await apiClient.deleteUser(target.id);
      const refreshedUsers = await refreshUsers();

      if (selectedUser?.id === target.id) {
        setSelectedUser(null);
        setSelectedRests([]);
      } else if (selectedUser) {
        const updatedSelected = refreshedUsers.find((u) => u.id === selectedUser.id) || null;
        setSelectedUser(updatedSelected);
        setSelectedRests(updatedSelected?.restaurantes?.map((r) => r.restID) || []);
      }

      setSuccess('Usuário removido com sucesso.');
    } catch (err: any) {
      const msg = err?.response?.data?.message || 'Erro ao remover usuário';
      setError(msg);
    } finally {
      setDeletingUserId(null);
    }
  };

  const handleResetPassword = async () => {
    if (!selectedUser) return;
    if (!canEditTarget(selectedUser)) {
      setError('Você não tem permissão para redefinir senha deste usuário.');
      return;
    }

    if (!newPassword || !newPasswordConfirm) {
      setError('Preencha e confirme a nova senha.');
      return;
    }

    if (newPassword !== newPasswordConfirm) {
      setError('As senhas digitadas não conferem.');
      return;
    }

    try {
      setResettingPassword(true);
      setError('');
      setSuccess('');
      await apiClient.resetUserPassword(selectedUser.id, newPassword);
      setNewPassword('');
      setNewPasswordConfirm('');
      setSuccess('Senha redefinida com sucesso.');
    } catch (err: any) {
      const rawMsg = err?.response?.data?.message;
      const msg = Array.isArray(rawMsg)
        ? rawMsg.join('; ')
        : rawMsg || 'Erro ao redefinir senha';
      setError(msg);
    } finally {
      setResettingPassword(false);
    }
  };

  const sortedUsers = useMemo(
    () => [...users].sort((a, b) => a.name.localeCompare(b.name)),
    [users],
  );

  const handleCreateAdmin = async (event: FormEvent) => {
    event.preventDefault();
    if (sessionRole !== 'SUPER_ADMIN') {
      setError('Apenas SUPER_ADMIN pode criar usuários Administrador.');
      return;
    }

    if (adminPassword !== adminPasswordConfirm) {
      setError('As senhas digitadas não conferem.');
      setSuccess('');
      return;
    }

    try {
      setCreatingAdmin(true);
      setError('');
      setSuccess('');

      await apiClient.register({
        name: adminName.trim(),
        email: adminEmail.trim().toLowerCase(),
        password: adminPassword,
        role: 'ADMIN',
      });

      await refreshUsers();
      setAdminName('');
      setAdminEmail('');
      setAdminPassword('');
      setAdminPasswordConfirm('');
      setSuccess('Administrador criado com sucesso.');
    } catch (err: any) {
      const rawMsg = err?.response?.data?.message;
      const msg = Array.isArray(rawMsg)
        ? rawMsg.join('; ')
        : rawMsg || 'Erro ao criar administrador';
      setError(msg);
    } finally {
      setCreatingAdmin(false);
    }
  };

  if (authorized === null) {
    return (
      <Layout>
        <div className={styles.container}>
          <p className={styles.muted}>Verificando permissões...</p>
        </div>
      </Layout>
    );
  }

  return (
    <Layout>
      <div className={styles.container}>
        <div className={styles.pageHeader}>
          <div>
            <p className={styles.kicker}>Administrador</p>
            <h1>Usuários</h1>
            <p className={styles.subtitle}>
              Gerencie funções, acessos, redefinição de senha e remoção de usuários. Apenas
              SUPER_ADMIN cria ou promove contas ADMIN.
            </p>
          </div>
        </div>

        {error && <div className={styles.error}>{error}</div>}
        {success && <div className={styles.info}>{success}</div>}

        {sessionRole === 'SUPER_ADMIN' && (
          <div className={styles.section}>
            <div className={styles.sectionHeader}>
              <div>
                <h2 style={{ margin: 0 }}>Criar Administrador</h2>
                <p className={styles.metaText}>
                  Apenas SUPER_ADMIN pode cadastrar contas com função Administrador.
                </p>
              </div>
            </div>

            <form onSubmit={handleCreateAdmin}>
              <div className={styles.inputRow}>
                <div className={styles.inputGroup}>
                  <label>Nome</label>
                  <input
                    value={adminName}
                    onChange={(e) => setAdminName(e.target.value)}
                    required
                  />
                </div>

                <div className={styles.inputGroup}>
                  <label>E-mail</label>
                  <input
                    type="email"
                    value={adminEmail}
                    onChange={(e) => setAdminEmail(e.target.value)}
                    required
                  />
                </div>

                <div className={styles.inputGroup}>
                  <label>Senha</label>
                  <input
                    type="password"
                    value={adminPassword}
                    onChange={(e) => setAdminPassword(e.target.value)}
                    minLength={12}
                    maxLength={128}
                    required
                  />
                  <span className={styles.metaText}>
                    Mínimo 12 caracteres com maiúscula, minúscula, número e símbolo.
                  </span>
                </div>

                <div className={styles.inputGroup}>
                  <label>Confirmar senha</label>
                  <input
                    type="password"
                    value={adminPasswordConfirm}
                    onChange={(e) => setAdminPasswordConfirm(e.target.value)}
                    minLength={12}
                    maxLength={128}
                    required
                  />
                </div>
              </div>

              <div className={styles.filters}>
                <button
                  type="submit"
                  className={styles.btnPrimary}
                  disabled={creatingAdmin}
                >
                  {creatingAdmin ? 'Criando...' : 'Criar Administrador'}
                </button>
              </div>
            </form>
          </div>
        )}

        <div className={styles.section}>
          <div className={styles.sectionHeader}>
            <div>
              <h2 style={{ margin: 0 }}>Usuários cadastrados</h2>
              <p className={styles.metaText}>Selecione um usuário para editar ou remover.</p>
            </div>
          </div>
          {loading ? (
            <p className={styles.muted}>Carregando...</p>
          ) : (
            <div className={styles.tableWrapper}>
              <table className={styles.table}>
                <thead>
                  <tr>
                    <th>Nome</th>
                    <th>Email</th>
                    <th>Função</th>
                    <th>Restaurantes</th>
                    <th>Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {sortedUsers.map((u) => (
                    <tr key={u.id}>
                      <td className={styles.name}>{u.name}</td>
                      <td>{u.email}</td>
                      <td>{roleLabel[u.role] || u.role}</td>
                      <td>
                        {u.role === 'ADMIN' || u.role === 'SUPER_ADMIN'
                          ? 'Todos'
                          : u.restaurantes?.map((r) => r.restID).join(', ') || '—'}
                      </td>
                      <td style={{ display: 'flex', gap: 8 }}>
                        <button
                          type="button"
                          className={styles.btnInfo}
                          onClick={() => handleSelectUser(u)}
                          disabled={!canEditTarget(u)}
                          title={!canEditTarget(u) ? 'Sem permissão para editar' : ''}
                        >
                          Editar
                        </button>
                        <button
                          type="button"
                          className={styles.btnDanger}
                          onClick={() => handleDeleteUser(u)}
                          disabled={!canEditTarget(u) || deletingUserId === u.id}
                          title={!canEditTarget(u) ? 'Sem permissão para remover' : ''}
                        >
                          {deletingUserId === u.id ? 'Removendo...' : 'Remover'}
                        </button>
                      </td>
                    </tr>
                  ))}
                  {sortedUsers.length === 0 && (
                    <tr>
                      <td colSpan={5} className={styles.emptyCell}>
                        Nenhum usuário encontrado.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {selectedUser && (
          <div className={styles.section} ref={editorRef}>
            <div className={styles.sectionHeader}>
              <div>
                <h2 style={{ margin: 0 }}>Editar {selectedUser.name}</h2>
                <p className={styles.metaText}>
                  Gerente deve ter 1 restaurante; Supervisor pode ter vários; Administrador ignora
                  seleção. Use os campos abaixo para redefinir a senha em caso de perda.
                </p>
              </div>
            </div>

            <div className={styles.inputRow}>
              <div className={styles.inputGroup}>
                <label>Função</label>
                <select value={role} onChange={(e) => setRole(e.target.value)}>
                  {roleOptions.map((option) => (
                    <option key={option} value={option}>
                      {roleLabel[option] || option}
                    </option>
                  ))}
                </select>
              </div>
              <div className={styles.inputGroup}>
                <label>Restaurantes atribuídos</label>
                <div className={styles.summaryGridSmall}>
                  {restaurantes.map((r) => {
                    const checked = selectedRests.includes(r.restID);
                    const disabledSelection = role === 'ADMIN';
                    return (
                      <label
                        key={r.restID}
                        className={styles.summaryCard}
                        style={{
                          borderColor: checked ? '#6366f1' : '#e5e7eb',
                          boxShadow: checked ? '0 4px 12px rgba(99,102,241,0.12)' : undefined,
                          cursor: disabledSelection ? 'not-allowed' : 'pointer',
                          display: 'flex',
                          gap: '12px',
                          alignItems: 'center',
                          opacity: disabledSelection ? 0.7 : 1,
                        }}
                      >
                        <input
                          type="checkbox"
                          checked={checked}
                          onChange={() => toggleRest(r.restID)}
                          disabled={disabledSelection}
                        />
                        <div>
                          <div className={styles.name}>{r.name}</div>
                          <div className={styles.metaText}>ID: {r.restID}</div>
                        </div>
                      </label>
                    );
                  })}
                </div>
              </div>
            </div>

            <div className={styles.inputRow}>
              <div className={styles.inputGroup}>
                <label>Nova senha</label>
                <input
                  type="password"
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  minLength={12}
                  maxLength={128}
                  placeholder="Nova senha"
                />
              </div>
              <div className={styles.inputGroup}>
                <label>Confirmar nova senha</label>
                <input
                  type="password"
                  value={newPasswordConfirm}
                  onChange={(e) => setNewPasswordConfirm(e.target.value)}
                  minLength={12}
                  maxLength={128}
                  placeholder="Repita a nova senha"
                />
                <span className={styles.metaText}>
                  Mínimo 12 caracteres com maiúscula, minúscula, número e símbolo.
                </span>
              </div>
            </div>

            <div className={styles.filters}>
              <button
                type="button"
                className={styles.btnWarning}
                onClick={handleResetPassword}
                disabled={loading || resettingPassword}
              >
                {resettingPassword ? 'Redefinindo senha...' : 'Redefinir senha'}
              </button>
              <button
                type="button"
                className={styles.btnPrimary}
                onClick={handleSave}
                disabled={loading}
              >
                {loading ? 'Salvando...' : 'Salvar alterações'}
              </button>
              <button
                type="button"
                className={styles.btnSecondary}
                onClick={() => setSelectedUser(null)}
                disabled={loading}
              >
                Fechar
              </button>
            </div>
          </div>
        )}
      </div>
    </Layout>
  );
}
